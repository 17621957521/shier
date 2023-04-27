import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shier/utils/file_utils.dart';
import 'package:shier/utils/user_info.dart';
import 'package:shier/utils/web_dav_utils.dart';
import 'package:webdav_client/webdav_client.dart';

class BookUtils {
  ///获取书列表
  static Future<List<BookBean>> getBookList() async {
    var list = await WebDavUtils.getList("${WebDavUtils.basePath}/books");
    return list.map((file) => BookBean.fromFile(file)).toList();
  }

  ///保存阅读进度到本地
  static Future<void> saveBookInfoToLocal(BookBean book) async {
    await FileUtils.setString(book.bookKey, json.encode(book.toJson()));
  }

  ///加载本地的阅读信息
  static Future<void> getBookInfoFromLocal(BookBean book) async {
    var bookInfoString = await FileUtils.getString(book.bookKey);
    if (bookInfoString?.isNotEmpty ?? false) {
      var jsonMap = json.decode(bookInfoString!);
      book.bookLength = jsonMap["bookLength"] ?? 1;
      book.isLoad = jsonMap["isLoad"] ?? false;
      book.manIndex = jsonMap["manIndex"] ?? 0;
      book.womanIndex = jsonMap["womanIndex"] ?? 0;
      if (book.isLoad) {
        book.contentList =
            await FileUtils.getStringList(book.bookContentKey) ?? [];
      }
    }
  }

  ///同步阅读进度
  static Future<void> syncBookInfo(BookBean book) async {
    var webBookInfoString = await WebDavUtils.readFile(book.bookConfigPath);
    if (webBookInfoString.isNotEmpty) {
      //获取对方的进度
      var jsonMap = json.decode(webBookInfoString);
      if (UserInfo.sex == 0) {
        book.manIndex = jsonMap["manIndex"] ?? 0;
        //当前自身阅读进度为0时加载远端阅读进度
        if (book.womanIndex == 0 && (jsonMap["womanIndex"] ?? 0) != 0) {
          book.womanIndex = jsonMap["womanIndex"] ?? 0;
        }
      } else {
        book.womanIndex = jsonMap["womanIndex"] ?? 0;
        //当前自身阅读进度为0时加载远端阅读进度
        if (book.manIndex == 0 && (jsonMap["manIndex"] ?? 0) != 0) {
          book.manIndex = jsonMap["manIndex"] ?? 0;
        }
      }
      if (book.bookLength == 1) {
        book.bookLength = jsonMap["bookLength"] ?? 1;
      }
    }
    //上传的自身进度
    await WebDavUtils.writeFile(
        book.bookConfigPath, json.encode(book.toJson()));
    saveBookInfoToLocal(book);
  }

  ///书下载
  static Future<void> downloadBook(BookBean book) async {
    EasyLoading.showProgress(0);
    String fileContent =
        await WebDavUtils.readFile(book.path, onProgress: (index, total) {
      EasyLoading.showProgress(index / total);
    });
    if (fileContent.isNotEmpty) {
      //段落切分
      var contentList = fileContent.split("\n");
      //过滤空行
      List<String> filterList = [];
      for (var element in contentList) {
        if (element.trim().isNotEmpty) {
          filterList.add(element);
        }
      }
      //存储
      if (filterList.isNotEmpty) {
        await FileUtils.setStringList(book.bookContentKey, filterList);
        book.contentList = filterList;
        book.bookLength = filterList.length;
        book.isLoad = true;
        saveBookInfoToLocal(book);
      }
    }
    EasyLoading.dismiss();
  }
}

class BookBean {
  String path = "";
  String fileName = "";
  int bookLength = 1;
  int manIndex = 0;
  int womanIndex = 0;
  bool isLoad = false;
  List<String> contentList = [];
  String get bookConfigPath =>
      "${WebDavUtils.basePath}/bookConfig/$fileName.config";
  String get bookKey => "book_config_$path";
  String get bookContentKey => "book_content_$path";
  int get readIndex => UserInfo.sex == 0 ? womanIndex : manIndex;
  set readIndex(int index) {
    if (UserInfo.sex == 0) {
      womanIndex = index;
    } else {
      manIndex = index;
    }
    BookUtils.saveBookInfoToLocal(this);
  }

  BookBean.fromFile(File file) {
    path = file.path!;
    fileName = file.name!;
    BookUtils.getBookInfoFromLocal(this);
  }

  Map<String, dynamic> toJson() => {
        'bookLength': bookLength,
        'manIndex': manIndex,
        'womanIndex': womanIndex,
        'isLoad': isLoad,
      };
}
