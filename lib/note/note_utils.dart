import 'dart:convert';

import 'package:shier/utils/file_utils.dart';
import 'package:shier/utils/web_dav_utils.dart';
import 'package:webdav_client/webdav_client.dart';

class NoteUtils {
  ///获取备忘录列表
  static Future<List<NoteBean>> getNoteList() async {
    var list = await WebDavUtils.getList("${WebDavUtils.basePath}/note");
    return list.map((file) => NoteBean.fromFile(file)).toList();
  }

  ///编辑新增备忘录信息
  static Future<void> updateNote(NoteBean note) async {
    var path = note.path;
    var content = json.encode(note.toJson());
    await WebDavUtils.writeFile(path, content);
    await FileUtils.writeFileToLocal(path, content);
  }

  ///删除备忘录
  static Future<void> deleteNote(NoteBean note) async {
    await WebDavUtils.deletePath(note.path);
  }

  ///获取从网盘中获取备忘录详情
  static Future<NoteBean> getNoteDetail(NoteBean note) async {
    var fileContent = await WebDavUtils.readFile(note.path);
    if (fileContent.isNotEmpty) {
      await FileUtils.writeFileToLocal(note.path, fileContent);
      var jsonMap = json.decode(fileContent);
      var title = jsonMap["title"] ?? "";
      var content = jsonMap["content"] ?? "";
      note.title = title;
      note.content = content;
    }
    return note;
  }
}

class NoteBean {
  String path = "";
  String fileName = "";
  String title = "";
  String content = "";

  NoteBean(
      {required this.path,
      required this.fileName,
      this.title = "",
      this.content = ""});

  NoteBean.now() {
    fileName = DateTime.now().millisecondsSinceEpoch.toString();
    path = "${WebDavUtils.basePath}/note/note_$fileName";
  }

  NoteBean.fromFile(File file) {
    path = file.path!;
    fileName = file.name!;
    //加载本地缓存
    FileUtils.readFileFromLocal(path).then((value) {
      if (value?.isNotEmpty ?? false) {
        var jsonMap = json.decode(value!);
        title = jsonMap["title"] ?? "";
        content = jsonMap["content"] ?? "";
      }
    });
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };
}
