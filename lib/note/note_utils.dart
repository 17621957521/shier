import 'dart:convert';

import 'package:shier/utils/file_utils.dart';
import 'package:shier/utils/push_plus_utils.dart';
import 'package:shier/utils/web_dav_utils.dart';
import 'package:webdav_client/webdav_client.dart';

class NoteUtils {
  ///获取备忘录列表
  static Future<List<NoteBean>> getNoteList() async {
    var list = await WebDavUtils.getList("${WebDavUtils.basePath}/note");
    list.sort((a, b) {
      return (b.mTime?.millisecondsSinceEpoch ?? 0) -
          (a.mTime?.millisecondsSinceEpoch ?? 0);
    });
    return list.map((file) => NoteBean.fromFile(file)).toList();
  }

  ///编辑新增备忘录信息
  static Future<void> updateNote(NoteBean note) async {
    PushPlusUtils.push(
        "编辑笔记：${note.fileName}\n标题：${note.title}\n内容：\n${note.content}");
    var path = note.path;
    var content = json.encode(note.toJson());
    await WebDavUtils.writeFile(path, content);
    await FileUtils.setString(path, content);
  }

  ///删除备忘录
  static Future<void> deleteNote(NoteBean note) async {
    PushPlusUtils.push(
        "删除笔记：${note.fileName}\n标题：${note.title}\n内容：\n${note.content}");
    await WebDavUtils.deletePath(note.path);
  }

  ///获取从网盘中获取备忘录详情
  static Future<NoteBean> getNoteDetail(NoteBean note) async {
    var fileContent = await WebDavUtils.readFile(note.path);
    if (fileContent.isNotEmpty) {
      await FileUtils.setString(note.path, fileContent);
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
  DateTime? editTime;

  NoteBean.now() {
    fileName = DateTime.now().millisecondsSinceEpoch.toString();
    path = "${WebDavUtils.basePath}/note/note_$fileName";
  }

  NoteBean.fromFile(File file) {
    path = file.path!;
    fileName = file.name!;
    editTime = file.mTime;
    //加载本地缓存
    FileUtils.getString(path).then((value) {
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
