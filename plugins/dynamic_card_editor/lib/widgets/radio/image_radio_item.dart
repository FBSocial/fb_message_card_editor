import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class ImageRadioItem extends StatelessWidget {
  final RadioData data;
  final ValueChanged<int>? onChanged;
  final int index;
  final bool absorbing;
  final TempWidgetConfig? config;

  const ImageRadioItem({
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

    final pre = cur?.pre ?? '';
    final typeData = cur?.radioTypeData as ImageRadioTypeData?;
    final String text = typeData?.text ?? '';
    final pixel = MediaQuery.of(context).devicePixelRatio;
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
            if (pre.isNotEmpty) ...[
              Text(
                pre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle1,
              ),
              const SizedBox(width: 8),
            ],
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ResizeImage(
                    NetworkImage(typeData?.image ?? ''),
                    width: 48 * pixel.toInt(),
                    allowUpscaling: true,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            if (text.isNotEmpty) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
