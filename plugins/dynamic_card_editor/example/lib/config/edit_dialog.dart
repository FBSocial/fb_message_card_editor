import 'dart:convert';
import 'dart:math';

import 'package:dynamic_card/ast/all.dart';
import 'package:dynamic_card/widget_nodes/all.dart';
import 'package:dynamic_card/widgets/all.dart';
import 'package:flutter/material.dart';

import 'all.dart';
import 'json_format.dart';
import 'toast_widget.dart';

class EditDialog extends StatefulWidget {
  final Map json;
  final WidgetNode node;
  final NodeController nodeController;

  const EditDialog({Key key, this.json, this.node, this.nodeController})
      : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  String _type;
  TextEditingController _editController;

  @override
  void initState() {
    final map = widget.json ?? {};
    final json = formatJson(map, 0);
    _type = widget.node?.runtimeType?.toString() ?? '';
    _editController = TextEditingController(text: json);
    super.initState();
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => pop(context),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.1),
        body: Center(
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_type),
                      SizedBox(width: 4),
                      InkWell(
                        child: Icon(
                          Icons.info_outline,
                          color: color3,
                          size: 14,
                        ),
                        onTap: () {
                          FullScreenDialog.getInstance().showDialog(
                              context, NodeInfoDialog(node: widget.node));
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: color3.withOpacity(0.2),
                ),
                Container(
                  width: 350,
                  constraints:
                      BoxConstraints(maxHeight: min(size.height - 100, 600)),
                  child: TextField(
                    controller: _editController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: '输入json',
                      hintStyle: textStyle1.copyWith(color: color3),
                    ),
                    maxLines: null,
                  ),
                ),
                Container(
                  height: 1,
                  color: color3.withOpacity(0.2),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 14),
                      child: InkWell(
                        onTap: () => pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: color3, width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              '取消',
                              style: textStyle1.copyWith(
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 12, 14),
                      child: InkWell(
                        onTap: () {
                          try {
                            final json = jsonDecode(_editController.text);
                            final node = JsonToNodeParser.instance.toNode(
                              json,
                              config: TempWidgetConfig(
                                  controller: widget.nodeController),
                            );
                            pop(context, value: node);
                          } on Exception catch (e) {
                            ToastWidget().showToast('json转换错误:$e');
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: color4, width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              '确认',
                              style: textStyle2.copyWith(
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void pop<T>(BuildContext context, {T value}) =>
    Navigator.of(context).pop(value);
