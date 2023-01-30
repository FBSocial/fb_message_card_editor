import 'dart:math';

import 'package:dynamic_card/ast/all.dart';
import 'package:flutter/material.dart';

import 'all.dart';

class NodeInfoDialog extends StatelessWidget {
  final WidgetNode node;

  const NodeInfoDialog({Key key, @required this.node}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final desChildren = node.getDescription().children ?? [];
    return GestureDetector(
      onTap: () => pop(context),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.1),
        body: Container(
          child: Center(
            child: Container(
              width: 500,
              color: Colors.white,
              constraints:
                  BoxConstraints(maxHeight: min(size.height - 100, 600)),
              child: Table(
                border: TableBorder.all(color: Colors.blueAccent),
                children: List.generate(desChildren.length, (index) {
                  final cur = desChildren[index];
                  return TableRow(
                    children: List.generate(cur.children.length, (i) {
                      final curChild = cur.children[i];
                      return Padding(
                          child: SelectableText(curChild),
                          padding: EdgeInsets.all(10));
                    }),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
