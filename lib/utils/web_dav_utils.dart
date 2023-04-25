import 'dart:convert';
import 'dart:typed_data';

import 'package:webdav_client/webdav_client.dart';

class WebDavUtils {
  static String userName = "896745063@qq.com";
  static String password = "aud8fieee8jntvm2";
  static String url = "https://dav.jianguoyun.com/dav/";
  static String basePath = "/shier";

  static Client? _client;

  static Future<void> init() async {
    _client = newClient(
      url,
      user: userName,
      password: password,
      debug: true,
    );

    try {
      await _client?.ping();
      await _client?.mkdirAll("$basePath/note");
      // await _client?.mkdirAll("$basePath/log");
      // await _client?.mkdirAll("$basePath/chenStory");
      // await _client?.mkdirAll("$basePath/laoStory");
    } catch (e) {
      print('$e');
    }
  }

  ///获取文件列表
  static Future<List<File>> getList(String path) async {
    try {
      return await _client?.readDir(path) ?? [];
    } catch (e) {
      print('$e');
      return [];
    }
  }

  ///读取文件
  static Future<String> readFile(String path) async {
    try {
      var bytes = await _client?.read(path);
      return utf8.decode(bytes ?? []);
    } catch (e) {
      print('$e');
      return "";
    }
  }

  ///写入文件
  static Future<void> writeFile(String path, String text) async {
    try {
      await _client?.write(path, Uint8List.fromList(utf8.encode(text)));
    } catch (e) {
      print('$e');
    }
  }

  ///删除文件
  static Future<void> deletePath(String path) async {
    try {
      await _client?.remove(path);
    } catch (e) {
      print('$e');
    }
  }
}
