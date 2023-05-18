import 'package:flutter/services.dart';

class ServiceUtils {
  static const MethodChannel _methodChannel =
      OptionalMethodChannel('shier/service');

  static void startService(String title, String content) {
    _methodChannel.invokeMethod("startService", {
      "title": title,
      "content": content,
    });
  }

  static void stopService() {
    _methodChannel.invokeMethod("stopService");
  }
}
