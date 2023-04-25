import 'package:shared_preferences/shared_preferences.dart';
import 'package:shier/utils/web_dav_utils.dart';

class FileUtils {
  static SharedPreferences? _sp;
  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
  }

  static Future<void> writeFileToLocal(String path, String content) async {
    if (_sp == null) await init();
    await _sp?.setString(path, content);
  }

  static Future<String?> readFileFromLocal(String path) async {
    if (_sp == null) await init();
    return _sp?.getString(path);
  }

  static Future<String> readFile(String path) async {
    var spFile = await readFileFromLocal(path) ?? "";
    if (spFile.isNotEmpty) {
      return spFile;
    }
    var webFile = await WebDavUtils.readFile(path);
    if (webFile.isNotEmpty) await writeFileToLocal(path, webFile);
    return webFile;
  }
}
