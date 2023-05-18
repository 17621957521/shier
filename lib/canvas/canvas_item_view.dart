import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/canvas/canvas_utils.dart';
import 'package:shier/res/assets_res.dart';

class CanvasItemView extends StatelessWidget {
  final CanvasBean canvas;
  final void Function() onDelete;

  const CanvasItemView({Key? key, required this.canvas, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleView(),
                  editTimeView(),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onDelete,
              child: Image.asset(
                AssetsRes.ICON_DELETE,
                width: 20.w,
                height: 20.w,
              ),
            )
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
