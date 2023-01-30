import 'package:flutter/material.dart';

import '../all.dart';

class DividerWidget extends StatelessWidget {
  final TempWidgetConfig? config;

  const DividerWidget({Key? key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      width: config?.defaultWidth ?? defaultWidth,
      child: Container(
        height: 8.5,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: color3.withOpacity(0.2), width: 0.5),
          ),
        ),
      ),
    );
  }
}
