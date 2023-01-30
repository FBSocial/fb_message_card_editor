import 'package:dynamic_card/svg_icon.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter/material.dart';

import '../../widget_nodes/all.dart';
import '../all.dart';

class PkImageRadioItem extends StatelessWidget {
  final RadioData data;
  final ValueChanged<int>? onChanged;
  final int index;
  final bool? absorbing;
  final Color color;

  const PkImageRadioItem({
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

    final typeData = cur?.radioTypeData as PkImageRadioTypeData?;
    final text = typeData?.text ?? '';
    final url = typeData?.image ?? '';
    final selected = isSelected(value);
    final selectNum = typeData?.select ?? 0;
    final hasResult = (typeData?.total ?? 0) != 0;
    final total = typeData?.total ?? 1;
    final ratio = selectNum / total * 100;
    final childBox = Container(
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: selected ? color : Colors.transparent),
          borderRadius: selected
              ? BorderRadius.only(
                  topLeft: Radius.circular(3), topRight: Radius.circular(3))
              : BorderRadius.circular(3)),
      child: Column(
        children: [
          LayoutBuilder(builder: (context, cons) {
            final width = cons.maxWidth - 24;
            return Stack(
              children: [
                Container(
                  width: width,
                  height: width,
                  margin: EdgeInsets.fromLTRB(12, 12, 12, 7),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      image: DecorationImage(
                          image: NetworkImage(url), fit: BoxFit.cover)),
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
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              text,
              style: selected ? textStyle1.copyWith(color: color) : textStyle1,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
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
