import 'package:dynamic_card/dynamic_card.dart';
import 'package:flutter/material.dart';

import '../../widget_nodes/all.dart';
import '../all.dart';

class VoteTitleWidget extends StatelessWidget {
  final VoteTitleData data;
  final TempWidgetConfig? config;

  const VoteTitleWidget({Key? key, required this.data, this.config})
      : super(key: key);

  int get bg => data.bg ?? VoteTitleData.bgOne;

  List<Color> get bgColors {
    switch (bg) {
      case IconTitleData.bgOne:
        return colors1;
      case IconTitleData.bgTwo:
        return colors2;
      case IconTitleData.bgThree:
        return colors3;
      case IconTitleData.bgFour:
        return colors4;
      default:
        return colors1;
    }
  }

  Color get textColor {
    switch (bg) {
      case IconTitleData.bgOne:
        return blueColor;
      case IconTitleData.bgTwo:
        return Colors.white;
      case IconTitleData.bgThree:
        return color1;
      case IconTitleData.bgFour:
        return Colors.white;
      default:
        return blueColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: config?.defaultWidth ?? defaultWidth,
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: bgColors),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          ),
          child: Row(
            children: [
              Text(data.text ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    height: 1.25,
                    // fontWeight: FontWeight.bold,
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                height: 12,
                width: 0.5,
                color: textColor,
              ),
              Text(
                type == VoteTitleData.multi ? '多选' : '单选',
                style: textStyle1.copyWith(fontSize: 13, color: textColor),
              )
            ],
          ),
        ),
        Container(height: 8, color: Colors.white)
      ],
    );
  }

  int? get type => data.type;
}
