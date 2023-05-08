import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shier/home/home_page.dart';
import 'package:shier/utils/file_utils.dart';
import 'package:shier/utils/user_info.dart';
import 'package:shier/utils/web_dav_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WebDavUtils.init();
  Permission.storage.request().then((value) async {
    if (value.isDenied) {
      openAppSettings();
    } else {
      await FileUtils.init();
      await UserInfo.init();
      runApp(const MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return MaterialApp(
            title: '十二',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            home: const HomePage(),
            builder: EasyLoading.init(),
          );
        });
  }
}
