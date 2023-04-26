import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/book/book_utils.dart';
import 'package:shier/res/assets_res.dart';

class BookItemView extends StatelessWidget {
  final BookBean book;
  const BookItemView({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleView(),
            progressView(),
          ],
        ),
      ),
    );
  }

  ///标题
  Widget titleView() {
    return Text(
      book.fileName,
      style: TextStyle(fontSize: 16.w, color: Colors.black),
    );
  }

  Widget progressView() {
    return Container(
      margin: EdgeInsets.only(top: 10.w),
      child: Row(
        children: [
          progressItem(0),
          progressItem(1),
        ],
      ),
    );
  }

  Widget progressItem(int sexIndex) {
    String image = [AssetsRes.ICON_WOMAN, AssetsRes.ICON_MAN][sexIndex];
    int index = sexIndex == 0 ? book.womanIndex : book.manIndex;
    double progress = index / book.bookLength * 100;
    return SizedBox(
      height: 20.w,
      width: 100.w,
      child: Row(
        children: [
          Image.asset(
            image,
            width: 20.w,
            height: 20.w,
          ),
          SizedBox(width: 5.w),
          Text("${progress.toStringAsFixed(2)}%"),
        ],
      ),
    );
  }
}
