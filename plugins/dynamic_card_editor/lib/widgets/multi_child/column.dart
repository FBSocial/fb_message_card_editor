import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class ColumnWidget extends StatelessWidget {
  final List<Widget>? children;
  final TempWidgetConfig? config;

  const ColumnWidget({Key? key, this.children, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
          children: children ?? [],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        width: config?.defaultWidth ?? defaultWidth);
  }
}
