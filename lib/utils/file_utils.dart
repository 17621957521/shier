import 'package:shared_preferences/shared_preferences.dart';
import 'package:shier/utils/web_dav_utils.dart';

class FileUtils {
  static SharedPreferences? _sp;
  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    _sp ??= await SharedPreferences.getInstance();
    await _sp?.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    _sp ??= await SharedPreferences.getInstance();
    return _sp?.getString(key);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    _sp ??= await SharedPreferences.getInstance();
    await _sp?.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    _sp ??= await SharedPreferences.getInstance();
    return _sp?.getStringList(key);
  }

  static Future<String> readFile(String path) async {
    var spFile = await getString(path) ?? "";
    if (spFile.isNotEmpty) {
      return spFile;
    }
    var webFile = await WebDavUtils.readFile(path);
    if (webFile.isNotEmpty) await setString(path, webFile);
    return webFile;
  }
}
