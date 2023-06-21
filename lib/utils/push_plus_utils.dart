import 'package:shier/utils/http_utils.dart';
import 'package:shier/utils/user_info.dart';

class PushPlusUtils {
  static const String token = "419fad7756154f0abce230e120901874";
  static const String url = "http://www.pushplus.plus/send";

  static void push(String content) {
    HttpUtils.post(url, {
      "token": token,
      "title": "来自${["陈时", "劳时"][UserInfo.sex]}",
      "content": content,
      "template": "txt"
    });
  }
}
