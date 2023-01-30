import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class CommonRadioItem extends StatelessWidget {
  final RadioData data;
  final ValueChanged<int>? onChanged;
  final int index;
  final bool absorbing;
  final TempWidgetConfig? config;

  const CommonRadioItem({
    Key? key,
    required this.data,
    required this.index,
    this.onChanged,
    this.absorbing = false,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cur = data.details?[index];
    final value = data.details?[index].value;
    final text = (cur?.pre ?? '') +
        ((cur?.radioTypeData as CommonRadioTypeData?)?.text ?? '');
    return Container(
      constraints:
          BoxConstraints(minWidth: config?.defaultWidth ?? defaultWidth),
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: GestureDetector(
        onTap: () => onChanged?.call(index),
        child: Row(
          children: [
            AbsorbPointer(
              absorbing: absorbing,
              child: CustomRadio(
                value: isSelected(value),
                radioType: data.type,
                onChanged: (v) => onChanged?.call(index),
                config: config,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle1,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
