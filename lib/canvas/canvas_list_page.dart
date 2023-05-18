import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/canvas/canvas_detail_page.dart';
import 'package:shier/canvas/canvas_item_view.dart';
import 'package:shier/canvas/canvas_name_dialog.dart';
import 'package:shier/canvas/canvas_utils.dart';
import 'package:shier/res/assets_res.dart';
import 'package:shier/utils/my_color.dart';

class CanvasListPage extends StatefulWidget {
  const CanvasListPage({Key? key}) : super(key: key);

  @override
  State<CanvasListPage> createState() => _CanvasListPageState();
}

class _CanvasListPageState extends State<CanvasListPage> {
  List<CanvasBean> list = [];

  @override
  void initState() {
    loadList();
    super.initState();
  }

  void loadList() async {
    EasyLoading.show();
    list = await CanvasUtils.getCanvasList();
    EasyLoading.dismiss();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !EasyLoading.isShow;
      },
      child: Scaffold(
        backgroundColor: MyColor.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "一起来画画",
            style: TextStyle(fontSize: 16.w, color: Colors.black),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                CanvasNameDialog(
                  onSure: (String canvasName) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CanvasDetailPage(canvas: CanvasBean(canvasName));
                    })).then((value) {
                      loadList();
                    });
                  },
                ).show(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Image.asset(
                  AssetsRes.ICON_ADD,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(padding: EdgeInsets.all(10.w), child: _listView()),
        ),
      ),
    );
  }

  Widget _listView() {
    return list.isEmpty
        ? const Center(
            child: Text("没有画布，去新建一个吧"),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  EasyLoading.show();
                  var canvas = await CanvasUtils.getNoteDetail(list[index]);
                  EasyLoading.dismiss();
                  if (mounted) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CanvasDetailPage(canvas: canvas);
                    })).then((value) {
                      loadList();
                    });
                  }
                },
                child: CanvasItemView(
                  canvas: list[index],
                ),
              );
            },
            itemCount: list.length,
          );
  }
}
