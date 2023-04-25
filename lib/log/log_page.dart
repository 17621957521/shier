import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shier/log/log_item_view.dart';
import 'package:shier/log/log_utils.dart';
import 'package:shier/utils/my_color.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  List<String> logList = [];

  @override
  void initState() {
    super.initState();
    loadLog();
  }

  Future<void> loadLog() async {
    EasyLoading.show();
    logList = await LogUtils.getLogList();
    EasyLoading.dismiss();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      body: SafeArea(
        child: _listView(),
      ),
    );
  }

  Widget _listView() {
    return logList.isEmpty
        ? const Center(
            child: Text("没有日志"),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return LogItemView(
                log: logList[index],
              );
            },
            itemCount: logList.length,
          );
  }
}
