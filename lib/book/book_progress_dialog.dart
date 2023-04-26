import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookProgressDialog extends StatefulWidget {
  final int maxIndex;
  final void Function(int index) onChange;
  const BookProgressDialog(
      {Key? key, required this.maxIndex, required this.onChange})
      : super(key: key);

  void show(BuildContext context) {
    showDialog(context: context, builder: (content) => this);
  }

  @override
  State<BookProgressDialog> createState() => _BookProgressDialogState();
}

class _BookProgressDialogState extends State<BookProgressDialog> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var index = int.tryParse(controller.text) ?? 0;
    var btnEnable = index > 0 && index <= widget.maxIndex;

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
                decoration: InputDecoration(
                  hintText: "请输入要跳转的行数(1-${widget.maxIndex})",
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'\d')) //设置只允许输入数字
                ],
                keyboardType: TextInputType.number,
                onChanged: (str) {
                  setState(() {});
                },
              ),
            ),
            if (btnEnable)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.onChange(index);
                  Navigator.pop(context);
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
