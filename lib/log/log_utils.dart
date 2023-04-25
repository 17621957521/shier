import 'package:shier/utils/file_utils.dart';
import 'package:shier/utils/web_dav_utils.dart';

class LogUtils {
  static Future<void> addLog(String log) async {
    var now = DateTime.now();
    var path = "${WebDavUtils.basePath}/log/log_${now.millisecondsSinceEpoch}";
    var content = "${now.toString()}\n$log";
    await FileUtils.writeFileToLocal(path, content);
    await WebDavUtils.writeFile(path, content);
  }

  static Future<List<String>> getLogList() async {
    List<String> result = [];
    // var fileList = await WebDavUtils.getList("${WebDavUtils.basePath}/log");
    // //排序
    // fileList.sort((a, b) {
    //   return (b.mTime?.millisecondsSinceEpoch ?? 0) -
    //       (a.mTime?.millisecondsSinceEpoch ?? 0);
    // });
    // for (var logFile in fileList) {
    //   if (logFile.path != null) {
    //     var content = await FileUtils.readFile(logFile.path!);
    //     result.add(content);
    //     if (result.length > 20) {
    //       break;
    //     }
    //   }
    // }
    return result;
  }
}
