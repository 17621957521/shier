import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shier/note/note_list_page.dart';
import 'package:shier/res/assets_res.dart';
import 'package:shier/user/user_sex_page.dart';
import 'package:shier/utils/file_utils.dart';
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
    Permission.storage.request().then((value) async {
      if (value.isDenied) {
        openAppSettings();
      } else {
        await FileUtils.init();
        await UserInfo.init();
        if (UserInfo.sex == -1) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const UserSexPage()));
          }
        } else {
          if (mounted) {
            setState(() {});
          }
        }
      }
    });
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
                margin: EdgeInsets.all(10.w),
                width: 360.w,
                child: Wrap(
                  children: [
                    noteView(),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //       return const LogPage();
                    //     }));
                    //   },
                    //   child: const CardView(text: "日志"),
                    // ),
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
            "你好，${["陈时", "劳时"][UserInfo.sex]}",
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
        child: SizedBox(
          width: 165.w,
          height: 165.w,
          child: Center(
            child: Image.asset(
              AssetsRes.IMAGE__HOME_NOTE,
            ),
          ),
        ),
      ),
    );
  }
}
