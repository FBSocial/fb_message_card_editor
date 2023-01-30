import 'package:dynamic_card/svg_icon.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter/material.dart';

import '../../widget_nodes/all.dart';
import '../all.dart';

class PkRadioItem extends StatelessWidget {
  final RadioData data;
  final ValueChanged<int>? onChanged;
  final int index;
  final bool? absorbing;
  final Color color;

  const PkRadioItem({
    Key? key,
    required this.data,
    this.onChanged,
    required this.index,
    this.absorbing,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cur = data.details?[index];
    final value = data.details?[index].value;
    final typeData = cur?.radioTypeData as PkRadioTypeData?;
    final text = typeData?.text ?? '';
    final selected = isSelected(value);
    final hasResult = (typeData?.total ?? 0) != 0;
    final selectNum = typeData?.select ?? 0;
    final total = typeData?.total ?? 1;
    final ratio = selectNum / total * 100;
    final childBox = LayoutBuilder(builder: (context, cons) {
      return Stack(
        children: [
          Container(
            width: cons.maxWidth,
            height: cons.maxWidth,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                border:
                    Border.all(color: selected ? color : Colors.transparent),
                borderRadius: selected
                    ? BorderRadius.only(
                        topLeft: Radius.circular(3),
                        topRight: Radius.circular(3))
                    : BorderRadius.circular(3)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  text,
                  style:
                      selected ? textStyle1.copyWith(color: color) : textStyle1,
                  maxLines: 4,
                ),
              ),
            ),
          ),
          if (selected)
            Positioned(
              top: 8,
              left: 8,
              child: WebsafeSvg.asset(
                this.color == color4
                    ? SvgIcons.checkInBlue
                    : SvgIcons.checkInRed,
                package: 'dynamic_card',
                width: 22,
                height: 22,
              ),
            ),
        ],
      );
    });
    final result = hasResult
        ? Column(
            children: [
              childBox,
              LayoutBuilder(builder: (context, cons) {
                return Container(
                  width: cons.maxWidth,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(3),
                      bottomRight: Radius.circular(3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$selectNum票 (${ratio.toStringAsFixed(1)}%)',
                      style: textStyle1.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ],
          )
        : childBox;
    return GestureDetector(onTap: () => onChanged?.call(index), child: result);
  }
}
