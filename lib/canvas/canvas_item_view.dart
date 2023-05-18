import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/canvas/canvas_utils.dart';

class CanvasItemView extends StatelessWidget {
  final CanvasBean canvas;

  const CanvasItemView({Key? key, required this.canvas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleView(),
            editTimeView(),
          ],
        ),
      ),
    );
  }

  ///标题
  Widget titleView() {
    return Text(
      canvas.canvasName,
      style: TextStyle(fontSize: 16.w, color: Colors.black),
    );
  }

  //上次编辑时间
  Widget editTimeView() {
    return Text("修改时间：${canvas.editTime.toString().split(".")[0]}");
  }
}
