import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class DisableButtonItem extends StatelessWidget {
  final int index;
  final List<ButtonDetailData> list;

  const DisableButtonItem({Key? key, required this.index, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFirst = index == 0;
    final isLast = index == list.length - 1;
    final cur = list[index];
    final style = textStyle1;

    return Expanded(
        child: Container(
      height: 48,
      margin: EdgeInsets.fromLTRB(isFirst ? 12 : 0, 0, isLast ? 12 : 0, 0),
      decoration: BoxDecoration(
        border:
            Border(top: BorderSide(color: color3.withOpacity(0.2), width: 0.5)),
      ),
      child: Center(
        child: Text(
          cur.text ?? '',
          style: style.copyWith(fontWeight: FontWeight.normal, color: color3),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ));
  }
}
