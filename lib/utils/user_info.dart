import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  static SharedPreferences? _sp;

  //性别 -1 未设置 0 女 1 男
  static int sex = -1;

  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
    sex = _sp?.getInt("userinfo_sex") ?? -1;
  }

  static Future<void> setSex(int sex) async {
    _sp ??= await SharedPreferences.getInstance();
    _sp?.setInt("userinfo_sex", sex);
  }
}
