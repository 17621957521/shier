import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/note/note_utils.dart';
import 'package:shier/res/assets_res.dart';
import 'package:shier/utils/my_color.dart';
import 'package:shier/utils/web_dav_utils.dart';
import 'package:shier/view/line_view.dart';

class NoteDetailPage extends StatefulWidget {
  final NoteBean? note;

  const NoteDetailPage({Key? key, this.note}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool isEdit = false;
  late NoteBean note;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    isEdit = widget.note == null;
    note = widget.note == null ? NoteBean.now() : widget.note!;
    super.initState();
    loadNoteDetail();
  }

  void loadNoteDetail() async {
    if (!isEdit) {
      EasyLoading.show();
      note = await NoteUtils.getNoteDetail(note);
      EasyLoading.dismiss();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void saveNoteDetail() async {
    if (isEdit) {
      note.title = titleController.text;
      note.content = contentController.text;
      await NoteUtils.updateNote(note);
    }
    isEdit = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEdit) {
          var result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.w))),
                  title: const Text('提示'),
                  content: const Text('你确定放弃此次修改吗?'),
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: const Text('确定'),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: const Text('取消'),
                    ),
                  ],
                ),
              ) ??
              false;
          if (result) {
            if (widget.note == null) {
              //新增数据
              return true;
            } else {
              //编辑数据
              if (mounted) {
                setState(() {
                  isEdit = false;
                });
              }
              return false;
            }
          } else {
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: MyColor.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: actionView(),
        ),
        body: SafeArea(
          child: isEdit ? editView() : previewView(),
        ),
      ),
    );
  }

  List<Widget> actionView() {
    if (isEdit) {
      //保存按钮
      return [
        GestureDetector(
          onTap: () {
            saveNoteDetail();
          },
          child: Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Image.asset(
              AssetsRes.ICON_SAVE,
              width: 20.w,
              height: 20.w,
            ),
          ),
        )
      ];
    } else {
      //编辑按钮
      return [
        GestureDetector(
          onTap: () async {
            var result = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.w))),
                    title: const Text('提示'),
                    content: const Text('确定删除吗?'),
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(true),
                        child: const Text('确定'),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(false),
                        child: const Text('取消'),
                      ),
                    ],
                  ),
                ) ??
                false;
            if (result) {
              await WebDavUtils.deletePath(note.path);
              if (mounted) {
                Navigator.of(context).pop(false);
              }
            }
          },
          child: Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Image.asset(
              AssetsRes.ICON_DELETE,
              width: 20.w,
              height: 20.w,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              titleController.text = note.title;
              contentController.text = note.content;
              isEdit = true;
            });
          },
          child: Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Image.asset(
              AssetsRes.ICON_EDIT,
              width: 20.w,
              height: 20.w,
            ),
          ),
        ),
      ];
    }
  }

  ///预览控件
  Widget previewView() {
    return Container(
      width: 360.w,
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30.w,
            child: Text(
              note.title.isNotEmpty ? note.title : note.fileName,
              style: TextStyle(
                fontSize: 20.w,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                note.content,
                style: TextStyle(
                  fontSize: 15.w,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editView() {
    return Container(
      width: 360.w,
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 340.w,
            height: 40.w,
            child: TextField(
              controller: titleController,
              style: TextStyle(fontSize: 15.w, color: Colors.black),
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "标题",
                hintStyle: TextStyle(
                  fontSize: 17.w,
                  color: Colors.black12,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const LineView(),
          Expanded(
            child: TextField(
              controller: contentController,
              style: TextStyle(
                fontSize: 15.w,
                color: Colors.black,
              ),
              maxLines: 100,
              decoration: InputDecoration(
                hintText: "内容",
                hintStyle: TextStyle(
                  fontSize: 15.w,
                  color: Colors.black12,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
