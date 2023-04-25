import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardView extends StatelessWidget {
  final String text;
  const CardView({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.w),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 16.w, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
