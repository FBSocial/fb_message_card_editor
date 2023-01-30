import 'package:flutter/material.dart';

import '../../widget_nodes/all.dart';
import '../all.dart';
import '../widget_config/style_config.dart';

class IconTitleWidget extends StatelessWidget {
  final IconTitleData data;
  final TempWidgetConfig? config;

  const IconTitleWidget({Key? key, required this.data, this.config})
      : super(key: key);

  bool get hasBg => data.type == WidgetName.iconBgTitle;

  bool get hasIcon => data.icon?.isNotEmpty ?? false;

  int get bg => data.bg ?? IconTitleData.bgOne;

  int get bgColorHex => data.bgColorHex ?? 0;

  int get textColorHex => data.textColorHex ?? 0;

  List<Color> get bgColors {
    if (bgColorHex != 0) {
      final color = Color(bgColorHex);
      return [color, color];
    }
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
    if (textColorHex != 0) return Color(textColorHex);
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

  FontWeight get fontWeight {
    return FontWeight.normal;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: config?.defaultWidth ?? defaultWidth,
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: hasBg ? null : Colors.white,
            gradient: hasBg
                ? LinearGradient(
                    colors: bgColors,
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasIcon)
                Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(data.icon ?? ''))),
                ),
              Expanded(
                child: Text(
                  data.text ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: fontWeight,
                    height: 1.25,
                  ),
                  maxLines: data.line == 0 ? 99 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (data.status == IconTitleData.statusInProgress)
                Container(
                  color: const Color(0x156179F2),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  margin: EdgeInsets.only(right: 4, top: 1),
                  child: Text(
                    '进行中',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6179F2)),
                  ),
                )
              else if (data.status == IconTitleData.statusFinish)
                Container(
                  color: const Color(0x158F959E),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  margin: EdgeInsets.only(right: 4, top: 1),
                  child: Text(
                    '已结束',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8F959E)),
                  ),
                )
            ],
          ),
        ),
        if (hasBg) Container(height: 12, color: Colors.white)
      ],
    );
  }
}
