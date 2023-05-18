import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shier/utils/web_dav_utils.dart';
import 'package:webdav_client/webdav_client.dart';

class CanvasUtils {
  ///获取画布列表
  static Future<List<CanvasBean>> getCanvasList() async {
    var list = await WebDavUtils.getList("${WebDavUtils.basePath}/canvas");
    list.sort((a, b) {
      return (b.mTime?.millisecondsSinceEpoch ?? 0) -
          (a.mTime?.millisecondsSinceEpoch ?? 0);
    });
    return list.map((file) => CanvasBean.fromFile(file)).toList();
  }

  ///删除画布
  static Future<void> deleteCanvas(CanvasBean canvas) async {
    await WebDavUtils.deletePath(canvas.path);
  }

  ///编辑新增备画布
  static Future<void> updateCanvas(CanvasBean canvas) async {
    var path = canvas.path;
    var content = canvas.toString();
    await WebDavUtils.writeFile(path, content);
  }

  ///从云盘中获取画布信息
  static Future<CanvasBean> getNoteDetail(CanvasBean canvas) async {
    var fileContent = await WebDavUtils.readFile(canvas.path);
    if (fileContent.isNotEmpty) {
      canvas.loadFromString(fileContent);
    }
    return canvas;
  }
}

class CanvasBean {
  String path = "";
  String canvasName = "";
  DateTime? editTime;
  List<CanvasPath> canvasPaths = [];

  CanvasBean(this.canvasName) {
    path = "${WebDavUtils.basePath}/canvas/$canvasName";
  }

  CanvasBean.fromFile(File file) {
    path = file.path!;
    canvasName = file.name!;
    editTime = file.mTime;
  }
  loadFromString(String string) {
    if (string.isNotEmpty) {
      List<dynamic> obj = jsonDecode(string);
      canvasPaths = obj.map((e) => CanvasPath.fromJson(e)).toList();
    }
  }

  @override
  String toString() {
    return jsonEncode(canvasPaths.map((e) => e.toJson()).toList());
  }
}

class CanvasPath {
  List<Offset> points = [];
  Color color = Colors.black;
  CanvasPath(this.points, this.color);

  CanvasPath.fromJson(dynamic json) {
    if (json != null) {
      color = Color(json["color"] ?? 0);
      (json["points"] ?? []).forEach((element) {
        points.add(Offset(element["dx"], element["dy"]));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "color": color.value,
      "points": points.map((e) => {"dx": e.dx, "dy": e.dy}).toList()
    };
  }
}
