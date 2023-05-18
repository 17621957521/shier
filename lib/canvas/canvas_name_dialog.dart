import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CanvasNameDialog extends StatefulWidget {
  final void Function(String canvasName) onSure;

  const CanvasNameDialog({Key? key, required this.onSure}) : super(key: key);

  @override
  State<CanvasNameDialog> createState() => _CanvasNameDialogState();

  void show(BuildContext context) {
    showDialog(context: context, builder: (content) => this);
  }
}

class _CanvasNameDialogState extends State<CanvasNameDialog> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var btnEnable = controller.text.isNotEmpty;
    return Dialog(
      child: Container(
        width: 300.w,
        height: 200.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              width: 180.w,
              height: 40.w,
              margin: EdgeInsets.only(top: 40.w),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "请输入画布名称",
                ),
                onChanged: (str) {
                  setState(() {});
                },
              ),
            ),
            if (btnEnable)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.pop(context);
                  widget.onSure(controller.text);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20.w),
                  width: 60.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: const Center(
                    child: Text(
                      "确定",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
