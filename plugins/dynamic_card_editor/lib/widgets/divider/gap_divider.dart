import 'package:dynamic_card/dynamic_card.dart';
import 'package:flutter/material.dart';

import '../all.dart';

class GapDividerWidget extends StatelessWidget {
  final TempWidgetConfig? config;
  final GapDividerData data;

  const GapDividerWidget({Key? key, required this.data, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      width: config?.defaultWidth ?? defaultWidth,
      height: data.height ?? 8.5,
    );
  }
}
