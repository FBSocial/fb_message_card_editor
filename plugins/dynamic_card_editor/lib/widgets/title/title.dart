import 'package:flutter/material.dart';
import '../../widget_nodes/all.dart';
import '../all.dart';

class TitleWidget extends StatelessWidget {
  final TitleData data;
  final TempWidgetConfig? config;

  const TitleWidget({Key? key, required this.data, this.config})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: config?.defaultWidth ?? defaultWidth,
      constraints: BoxConstraints(minHeight: 40),
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6), topRight: Radius.circular(6)),
      ),
      child: Text(data.text ?? '',
          style: TextStyle(
            fontSize: 15,
            color: color1,
            height: 1.25,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
