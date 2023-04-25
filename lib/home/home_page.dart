import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shier/note/note_list_page.dart';
import 'package:shier/res/assets_res.dart';
import 'package:shier/utils/file_utils.dart';
import 'package:shier/utils/my_color.dart';
import 'package:shier/utils/web_dav_utils.dart';

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
    WebDavUtils.init();
    Permission.storage.request().then((value) {
      if (value.isDenied) {
        openAppSettings();
      } else {
        FileUtils.init();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10.w),
          child: Wrap(
            children: [
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) {
              //       return const LogPage();
              //     }));
              //   },
              //   child: const CardView(text: "日志"),
              // ),
              GestureDetector(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
