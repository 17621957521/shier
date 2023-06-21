import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/canvas/canvas_color_picker_dialog.dart';
import 'package:shier/canvas/canvas_utils.dart';
import 'package:shier/res/assets_res.dart';
import 'package:shier/utils/my_color.dart';

class CanvasDetailPage extends StatefulWidget {
  final CanvasBean canvas;

  const CanvasDetailPage({Key? key, required this.canvas}) : super(key: key);

  @override
  State<CanvasDetailPage> createState() => _CanvasDetailPageState();
}

class _CanvasDetailPageState extends State<CanvasDetailPage> {
  List<Offset>? currPath;
  int? pointer;
  Color paintColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !EasyLoading.isShow;
      },
      child: Scaffold(
        backgroundColor: MyColor.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: actionView(),
        ),
        body: SafeArea(
          child: canvasView(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Container(
            color: paintColor,
          ),
          onPressed: () {
            CanvasColorPickerDialog(
              pickerColor: paintColor,
              onChange: (color) {
                setState(() {
                  paintColor = color;
                });
              },
            ).show(context);
          },
        ),
      ),
    );
  }

  Widget canvasView() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Listener(
            //用来监听用户的触摸行为
            child: Container(
              color: Colors.transparent,
            ),
            onPointerDown: (PointerDownEvent event) {
              if (pointer == null) {
                pointer = event.pointer;
                currPath = [];
                currPath?.add(globalToLocal(context, event.localPosition));
                setState(() {});
              }
            },
            onPointerMove: (PointerMoveEvent event) {
              if (pointer == event.pointer) {
                currPath?.add(globalToLocal(context, event.localPosition));
                setState(() {});
              }
            },
            onPointerUp: (PointerUpEvent event) {
              if (pointer == event.pointer) {
                pointer = null;
                widget.canvas.canvasPaths
                    .add(CanvasPath(currPath!, paintColor));
                currPath = null;
                setState(() {});
              }
            },
          ),
          RepaintBoundary(
            child: CustomPaint(
              painter:
                  CanvasPainter(context, widget.canvas, currPath, paintColor),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> actionView() {
    //保存按钮
    return [
      GestureDetector(
        onTap: () async {
          if (widget.canvas.canvasPaths.isNotEmpty) {
            widget.canvas.canvasPaths.removeLast();
            setState(() {});
          }
        },
        child: Container(
          margin: EdgeInsets.only(right: 10.w),
          child: Image.asset(
            AssetsRes.ICON_UNDO,
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
      GestureDetector(
        onTap: () async {
          EasyLoading.show();
          await CanvasUtils.updateCanvas(widget.canvas);
          EasyLoading.dismiss();
        },
        child: Container(
          margin: EdgeInsets.only(right: 10.w),
          child: Image.asset(
            AssetsRes.ICON_SAVE,
            width: 20.w,
            height: 20.w,
          ),
        ),
      )
    ];
  }
}

class CanvasPainter extends CustomPainter {
  final BuildContext context;
  final CanvasBean bean;
  final List<Offset>? currPath;
  final Color? currColor;

  CanvasPainter(
    this.context,
    this.bean,
    this.currPath,
    this.currColor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (var canvasPath in bean.canvasPaths) {
      drawLine(canvas, canvasPath.points, canvasPath.color);
    }
    if (currPath != null && currColor != null) {
      drawLine(canvas, currPath!, currColor!);
    }
  }

  void drawLine(Canvas canvas, List<Offset> points, Color color) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 2.w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    if (points.isNotEmpty) {
      var path = Path();
      var globalPoints = points.map((e) => localToGlobal(context, e)).toList();

      path.moveTo(globalPoints[0].dx, globalPoints[0].dy);
      for (int i = 1; i < globalPoints.length - 1; i++) {
        Offset midPoint = Offset(
            (globalPoints[i].dx + globalPoints[i + 1].dx) / 2,
            (globalPoints[i].dy + globalPoints[i + 1].dy) / 2);
        path.quadraticBezierTo(
          globalPoints[i].dx,
          globalPoints[i].dy,
          midPoint.dx,
          midPoint.dy,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

///将实际坐标转换成百分比坐标
Offset globalToLocal(BuildContext context, Offset offset) {
  var width = MediaQuery.of(context).size.width;
  return Offset(offset.dx / width, offset.dy / width);
}

///将百分比坐标转换成实际坐标
Offset localToGlobal(BuildContext context, Offset offset) {
  var width = MediaQuery.of(context).size.width;
  return Offset(offset.dx * width, offset.dy * width);
}
