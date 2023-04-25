import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineView extends StatelessWidget {
  const LineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      height: 1.w,
      color: Colors.grey.withOpacity(0.5),
    );
  }
}
