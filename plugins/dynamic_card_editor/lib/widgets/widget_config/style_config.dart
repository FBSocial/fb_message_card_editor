import 'package:flutter/material.dart';

abstract class AbstractStyleConfig {
  AbstractStyleConfig();

  AbstractStyleConfig.fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();

  String get keyName;
}

class IconTitleConfig extends AbstractStyleConfig {
  Color? textColor;
  Color? bgColor;

  IconTitleConfig({
    this.textColor = color1,
    this.bgColor = Colors.white,
  });

  IconTitleConfig.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) {
      this.textColor = color1;
      this.bgColor = Colors.white;
      return;
    }
    final iconTitleMap = map[keyName];
    if (iconTitleMap == null) return;
    final textColor = fromString(iconTitleMap['textC'], defaultColor: color1);
    final bgColor = fromString(iconTitleMap['bgC']);
    this.textColor = textColor;
    this.bgColor = bgColor;
  }

  Map<String, dynamic> toMap() => {
        keyName: {'textC': colorValue(textColor), 'bgC': colorValue(bgColor)}
      };

  @override
  String get keyName => 'icon_tit';
}

class TitleTextConfig extends AbstractStyleConfig {
  Color? titleColor;

  TitleTextConfig({this.titleColor = color1});

  TitleTextConfig.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) {
      this.titleColor = color1;
      return;
    }
    final iconTitleMap = map[keyName];
    if (iconTitleMap == null) return;
    final titleColor = fromString(iconTitleMap['titleC'], defaultColor: color1);
    this.titleColor = titleColor;
  }

  @override
  String get keyName => 'title_tx';

  @override
  Map<String, dynamic> toMap() => {
        keyName: {'titleC': colorValue(titleColor)}
      };
}

Color fromString(
  String color, {
  Color? defaultColor,
}) =>
    Color(int.tryParse(color, radix: 16) ??
        defaultColor as int? ??
        Colors.white as int);

String colorValue(Color? color) =>
    color.toString().split('(0x')[1].split(')')[0];

const color1 = Color(0xff1F2329);
const color2 = Color(0xff1F2125);
const color3 = Color(0xff8F959E);
const color4 = Color(0xff5562F2);
const color5 = Color(0xffF24848);
const color6 = Color(0xff646A73);
final blueColor = Color(0xff198CFE);

const colors1 = [Color(0x26198CFE), Color(0x07198CFE)];
const colors2 = [Color(0xff4E83FD), Color(0xff3371FF)];
const colors3 = [Color(0xffF5F5F8), Color(0xffE9EAEC)];
const colors4 = [Color(0xff6179F2), color4];

const textStyle1 = TextStyle(color: color1, fontSize: 14, height: 1.25);
const textStyle2 = TextStyle(color: color4, fontSize: 14, height: 1.25);
