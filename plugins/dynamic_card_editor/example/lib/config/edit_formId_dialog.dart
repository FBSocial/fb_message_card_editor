import 'dart:math';

import 'package:dynamic_card/widget_nodes/all.dart';
import 'package:dynamic_card/widgets/all.dart';
import 'package:flutter/material.dart';

class EditFormIdDialog extends StatefulWidget {
  final String formId;

  const EditFormIdDialog({Key key, this.formId}) : super(key: key);

  @override
  _EditFormIdDialogState createState() => _EditFormIdDialogState();
}

class _EditFormIdDialogState extends State<EditFormIdDialog> {
  TextEditingController _editController;

  @override
  void initState() {
    _editController = TextEditingController(text: widget.formId ?? '');
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
                      Text('修改formId'),
                      SizedBox(width: 4),
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
                      hintText: '输入formId',
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
                          pop(context, value: _editController.text);
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
