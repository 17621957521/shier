import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shier/book/book_progress_dialog.dart';
import 'package:shier/book/book_utils.dart';
import 'package:shier/res/assets_res.dart';
import 'package:shier/utils/ServiceUtils.dart';
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

  FlutterTts flutterTts = FlutterTts();
  String ttsState = "stopped";
  int readIndex = -1;

  @override
  void initState() {
    super.initState();
    initTTS();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (itemScrollController.isAttached) {
        itemScrollController.jumpTo(index: widget.book.readIndex);
      }
      itemPositionsListener.itemPositions.addListener(() {
        if (ttsState == "stopped") {
          var firstIndex = itemPositionsListener.itemPositions.value
              .map((e) => e.index)
              .toList()
              .reduce(min);
          if (widget.book.readIndex != firstIndex) {
            widget.book.readIndex = firstIndex;
            if (mounted) {
              setState(() {});
            }
          }
        }
      });
    });
  }

  void initTTS() {
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = "playing";
      });
    });
    flutterTts.setCompletionHandler(() {
      readIndex++;
      if (readIndex >= widget.book.contentList.length) {
        setState(() {
          ttsState = "stopped";
        });
      } else {
        readByIndex(readIndex);
      }
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = "stopped";
      });
    });
    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = "stopped";
      });
    });
    flutterTts.setPauseHandler(() {
      setState(() {
        ttsState = "paused";
      });
    });
    flutterTts.setContinueHandler(() {
      setState(() {
        ttsState = "continued";
      });
    });
  }

  void startRead() {
    readByIndex(widget.book.readIndex);
  }

  void stopRead() async {
    await flutterTts.stop();
    readIndex = -1;
    ServiceUtils.stopService();
    setState(() => ttsState = "stopped");
  }

  void readByIndex(int index) async {
    if (index >= widget.book.contentList.length) {
      if (ttsState == "playing") {
        stopRead();
      }
    } else {
      var content = widget.book.contentList[index];
      await flutterTts.speak(content);
      widget.book.readIndex = index;
      readIndex = index;
      itemScrollController.jumpTo(index: widget.book.readIndex);
      ServiceUtils.startService(
          widget.book.fileName, "$readIndex/${widget.book.contentList.length}");
      setState(() => ttsState = "playing");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (ttsState == "playing") {
          stopRead();
          return false;
        }
        return true;
      },
      child: Scaffold(
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
            readBtn(),
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: listView(),
          ),
        ),
      ),
    );
  }

  Widget readBtn() {
    return GestureDetector(
      onTap: () {
        if (ttsState == "playing") {
          stopRead();
          ttsState = "stopped";
        } else {
          startRead();
          ttsState = "playing";
        }
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        child: Image.asset(
          ttsState == "playing"
              ? AssetsRes.ICON_READ_STOP
              : AssetsRes.ICON_READ_START,
          width: 20.w,
          height: 20.w,
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
