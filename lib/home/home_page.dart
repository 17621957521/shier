import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/book/book_list_page.dart';
import 'package:shier/canvas/canvas_list_page.dart';
import 'package:shier/note/note_list_page.dart';
import 'package:shier/res/assets_res.dart';
import 'package:shier/user/user_sex_page.dart';
import 'package:shier/utils/my_color.dart';
import 'package:shier/utils/user_info.dart';

class HomePage extends StatefulWidget {
  //app主页
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (UserInfo.sex == -1) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const UserSexPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      body: SafeArea(
        child: Column(
          children: [
            welcomeView(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10.w, top: 10.w, bottom: 10.w),
                width: 360.w,
                child: Wrap(
                  spacing: 10.w,
                  runSpacing: 10.w,
                  children: [
                    noteView(),
                    booksView(),
                    canvasView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget welcomeView() {
    if (UserInfo.sex != -1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.w,
          ),
          Text(
            "你好鸭，${["陈时", "劳时"][UserInfo.sex]}",
            style: TextStyle(fontSize: 20.w),
          ),
          SizedBox(
            height: 10.w,
          ),
        ],
      );
    }
    return Container();
  }

  ///备忘录
  Widget noteView() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const NoteListPage();
        }));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: Container(
          color: Colors.white,
          width: 165.w,
          height: 165.w,
          child: Center(
            child: Image.asset(
              AssetsRes.IMAGE_HOME_NOTE,
            ),
          ),
        ),
      ),
    );
  }

  ///阅读
  Widget booksView() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const BookListPage();
        }));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: Container(
          color: Colors.white,
          width: 165.w,
          height: 165.w,
          child: Center(
            child: Image.asset(
              AssetsRes.IMAGE_HOME_BOOK,
            ),
          ),
        ),
      ),
    );
  }

  Widget canvasView() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const CanvasListPage();
        }));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: Container(
          color: Colors.white,
          width: 165.w,
          height: 165.w,
          child: Center(
            child: Image.asset(
              AssetsRes.IMAGE_HOME_CANVAS,
            ),
          ),
        ),
      ),
    );
  }
}
