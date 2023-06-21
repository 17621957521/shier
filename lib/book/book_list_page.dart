import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/book/book_item_view.dart';
import 'package:shier/book/book_read_page.dart';
import 'package:shier/book/book_utils.dart';
import 'package:shier/utils/my_color.dart';
import 'package:shier/utils/push_plus_utils.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<BookBean> list = [];
  @override
  void initState() {
    loadList();
    super.initState();
  }

  void loadList() async {
    EasyLoading.show();
    list = await BookUtils.getBookList();
    EasyLoading.dismiss();
    if (mounted) {
      setState(() {});
    }
    syncBookListInfo();
  }

  ///同步列表信息
  void syncBookListInfo() async {
    var list = this.list;
    for (var book in list) {
      await Future.delayed(const Duration(milliseconds: 100));
      await BookUtils.syncBookInfo(book);
      if (list != this.list) return; //列表已经被刷新了
      if (mounted) {
        setState(() {});
      }
    }
  }

  void itemClick(BookBean book) async {
    if (book.isLoad) {
      // 跳转到看书页
      toDetailPage(book);
    } else {
      // 下载书
      var result = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              title: const Text('提示'),
              content: const Text('当前书籍未下载，是否下载书籍'),
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
        await BookUtils.downloadBook(book);
        if (mounted) {
          if (book.isLoad) {
            toDetailPage(book);
          } else {
            EasyLoading.showToast("下载失败");
          }
        }
      }
    }
  }

  ///重新下载书
  void reloadBook(BookBean book) async {
    var result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.w))),
            title: const Text('提示'),
            content: const Text('是否重新下载书籍'),
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
      await BookUtils.downloadBook(book);
      if (mounted) {
        setState(() {});
      }
    }
  }

  //跳转到书籍内容页
  void toDetailPage(BookBean book) async {
    PushPlusUtils.push("开始看书：${book.fileName}");
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BookReadPage(book: book);
    }));
    PushPlusUtils.push("结束看书：${book.fileName}");
    await BookUtils.syncBookInfo(book);
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
            "一起看书鸭",
            style: TextStyle(fontSize: 16.w, color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10.w),
            child: _listView(),
          ),
        ),
      ),
    );
  }

  Widget _listView() {
    return list.isEmpty
        ? const Center(
            child: Text("书架为空"),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  itemClick(list[index]);
                },
                child: BookItemView(
                  book: list[index],
                  onReload: () {
                    reloadBook(list[index]);
                  },
                ),
              );
            },
            itemCount: list.length,
          );
  }
}
