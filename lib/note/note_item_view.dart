import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shier/note/note_utils.dart';

class NoteItemView extends StatelessWidget {
  final NoteBean note;

  const NoteItemView({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.w),
        child: Center(
          child: Text(
            note.title.isEmpty ? note.fileName : note.title,
            style: TextStyle(fontSize: 16.w, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
