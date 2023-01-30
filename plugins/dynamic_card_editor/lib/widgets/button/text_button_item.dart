import 'package:dynamic_card/dynamic_card.dart';
import 'package:flutter/material.dart';

import '../../widget_nodes/all.dart';
import '../all.dart';

class TextButtonItem extends StatelessWidget {
  final int index;
  final List<ButtonDetailData> list;
  final ButtonCallback? callback;
  final NodeController? nodeController;
  final bool disableClick;
  final String? formId;

  const TextButtonItem({
    Key? key,
    required this.index,
    required this.list,
    this.disableClick = false,
    this.callback,
    this.nodeController,
    this.formId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFirst = index == 0;
    final isLast = index == list.length - 1;
    final cur = list[index];
    final style = textStyle2;

    return Expanded(
        child: InkWell(
      onTap: disableClick
          ? null
          : () async {
              try {
                if (formId != null && formId!.isNotEmpty)
                  nodeController?.changeFormValue(formId, true);
                await (callback ?? cur.callback)
                    ?.call(ButtonCallbackParam(event: cur.event));
              } catch (e) {
                print('Button:$cur click error:$e');
              } finally {
                nodeController?.changeFormValue(formId, false);
              }
            },
      child: Container(
        height: 48,
        margin: EdgeInsets.fromLTRB(isFirst ? 12 : 0, 0, isLast ? 12 : 0, 0),
        decoration: BoxDecoration(
          border: Border(
              left: isFirst
                  ? BorderSide.none
                  : BorderSide(color: color3.withOpacity(0.2), width: 0.5),
              top: BorderSide(color: color3.withOpacity(0.2), width: 0.5)),
        ),
        child: Center(
          child: Text(
            cur.text ?? '',
            style: style.copyWith(
              fontWeight: FontWeight.normal,
              color: disableClick ? color3 : textStyle2.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ));
  }
}
