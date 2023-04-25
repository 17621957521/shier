import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/view/line_view.dart';

class LogItemView extends StatelessWidget {
  final String log;
  const LogItemView({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          child: Text(
            log,
            style: TextStyle(fontSize: 16.w, color: Colors.black),
          ),
        ),
        const LineView(),
      ],
    );
  }
}
