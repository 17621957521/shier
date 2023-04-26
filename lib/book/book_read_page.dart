import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shier/book/book_progress_dialog.dart';
import 'package:shier/book/book_utils.dart';
import 'package:shier/utils/my_color.dart';

class BookReadPage extends StatefulWidget {
  final BookBean book;
  const BookReadPage({Key? key, required this.book}) : super(key: key);

  @override
  State<BookReadPage> createState() => _BookReadPageState();
}

class _BookReadPageState extends State<BookReadPage> {
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      print(widget.book.readIndex);
      if (itemScrollController.isAttached) {
        itemScrollController.jumpTo(index: widget.book.readIndex);
      }
      itemPositionsListener.itemPositions.addListener(() {
        var firstIndex = itemPositionsListener.itemPositions.value.first.index;
        widget.book.readIndex = firstIndex;
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.book.fileName,
          style: TextStyle(fontSize: 16.w, color: Colors.black),
        ),
        actions: [
          progressView(),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: listView(),
        ),
      ),
    );
  }

  Widget progressView() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //显示进度弹窗
        BookProgressDialog(
          maxIndex: widget.book.contentList.length,
          onChange: (int index) {
            if (mounted) {
              widget.book.readIndex = index - 1;
              itemScrollController.jumpTo(index: widget.book.readIndex);
              setState(() {});
            }
          },
        ).show(context);
      },
      child: SizedBox(
        width: 80.w,
        height: 40.w,
        child: Center(
          child: Text(
              "${widget.book.readIndex + 1}/${widget.book.contentList.length}"),
        ),
      ),
    );
  }

  Widget listView() {
    return widget.book.contentList.isEmpty
        ? const Center(
            child: Text("内容为空"),
          )
        : ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.w),
                child: Text(
                  widget.book.contentList[index],
                  style: TextStyle(
                    fontSize: 16.w,
                    color: Colors.black,
                  ),
                ),
              );
            },
            itemCount: widget.book.contentList.length,
          );
  }
}
