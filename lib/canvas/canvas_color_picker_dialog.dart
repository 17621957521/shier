import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CanvasColorPickerDialog extends StatefulWidget {
  final Color pickerColor;
  final void Function(Color) onChange;
  const CanvasColorPickerDialog(
      {Key? key, required this.pickerColor, required this.onChange})
      : super(key: key);

  void show(BuildContext context) {
    showDialog(context: context, builder: (context) => this);
  }

  @override
  State<CanvasColorPickerDialog> createState() =>
      _CanvasColorPickerDialogState();
}

class _CanvasColorPickerDialogState extends State<CanvasColorPickerDialog> {
  Color pickerColor = Colors.black;
  @override
  void initState() {
    pickerColor = widget.pickerColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: (color) {
            setState(() => pickerColor = color);
          },
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('确定'),
          onPressed: () {
            widget.onChange(pickerColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
