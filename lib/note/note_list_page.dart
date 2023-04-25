import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/note/note_detail_page.dart';
import 'package:shier/note/note_item_view.dart';
import 'package:shier/note/note_utils.dart';
import 'package:shier/res/assets_res.dart';
import 'package:shier/utils/my_color.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<NoteBean> list = [];

  @override
  void initState() {
    loadList();
    super.initState();
  }

  void loadList() async {
    EasyLoading.show();
    list = await NoteUtils.getNoteList();
    EasyLoading.dismiss();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "备忘录",
          style: TextStyle(fontSize: 16.w, color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const NoteDetailPage();
              })).then((value) {
                loadList();
              });
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
        child: _listView(),
      ),
    );
  }

  Widget _listView() {
    return list.isEmpty
        ? const Center(
            child: Text("没有备忘录，去新建一个吧"),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NoteDetailPage(
                      note: list[index],
                    );
                  })).then((value) {
                    loadList();
                  });
                },
                child: NoteItemView(
                  note: list[index],
                ),
              );
            },
            itemCount: list.length,
          );
  }
}
