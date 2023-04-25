import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/home/home_page.dart';
import 'package:shier/res/assets_res.dart';
import 'package:shier/utils/my_color.dart';
import 'package:shier/utils/user_info.dart';

class UserSexPage extends StatefulWidget {
  const UserSexPage({Key? key}) : super(key: key);

  @override
  State<UserSexPage> createState() => _UserSexPageState();
}

class _UserSexPageState extends State<UserSexPage> {
  int sex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ["你是谁？", "陈时", "劳时"][sex + 1],
                style: TextStyle(fontSize: 20.w, color: Colors.black),
              ),
              SizedBox(height: 30.w),
              selectView(),
              SizedBox(height: 50.w),
              sureBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        selectImage(AssetsRes.ICON_WOMAN, 0),
        SizedBox(width: 20.w),
        selectImage(AssetsRes.ICON_MAN, 1),
      ],
    );
  }

  Widget selectImage(String image, int sexIndex) {
    return SizedBox(
      height: 100.w,
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (sex != sexIndex) {
              setState(() {
                sex = sexIndex;
              });
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.w),
            child: AnimatedContainer(
                width: sex == sexIndex ? 100.w : 70.w,
                height: sex == sexIndex ? 100.w : 70.w,
                duration: const Duration(milliseconds: 100),
                child: Image.asset(image)),
          )),
    );
  }

  Widget sureBtn() {
    return sex == -1
        ? SizedBox(width: 100.w, height: 100.w)
        : GestureDetector(
            onTap: () async {
              await UserInfo.setSex(sex);
              if (mounted) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(50.w),
              ),
              child: const Center(
                child: Text(
                  "确定",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
  }
}
