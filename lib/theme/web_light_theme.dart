import 'package:flutter/material.dart';

import 'const.dart';
import 'default_theme.dart';
import 'no_splash.dart';

/// 深色主题
class WebLightTheme extends DefaultTheme {
  WebLightTheme() {
    tagStyle = TextStyle(color: color66, fontSize: 12);
    timeStyle = TextStyle(color: color99, fontSize: 14);
    replyStyle = TextStyle(color: color99, fontSize: 14);
    numStyle = TextStyle(color: color66, fontSize: 14);
    contentStyle = const TextStyle(fontSize: 16);
    nameStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: color99,
    );
    smallNameStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: color99,
    );

    themeData = webLightTheme;

    appBarButtonTextStyle = const TextStyle(
        fontWeight: FontWeight.normal, fontSize: 16, color: Color(0xFF4F545C));

    backgoundColor3 = Colors.white;
    backgoundColor4 = const Color(0xFFE0E2E6);
    backgoundColor5 = Colors.white;
  }
}

final ThemeData webLightTheme = ThemeData(
    primarySwatch: primaryColor,
    brightness: Brightness.light,
    highlightColor: Colors.transparent,
    splashFactory: const NoSplashFactory(),
    toggleableActiveColor: primaryColor,
    hoverColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black, size: 20),
      actionsIconTheme: IconThemeData(color: primaryColor),
    ),
    sliderTheme: const SliderThemeData(
//    valueIndicatorShape: SliderComponentShape.noOverlay,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 8,
          disabledThumbRadius: 0,
          elevation: 0,
          pressedElevation: 2,
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: 8,
        )),
    dividerTheme: const DividerThemeData(
        color: Color(0xFFDEE0E3), space: 0, thickness: 1),
    scaffoldBackgroundColor: const Color(0xFFF2F3F5),
    // a1
    backgroundColor: Colors.white,
    // a2
    iconTheme: const IconThemeData(color: Color(0xFF8F959E)),
    textTheme: TextTheme(
      headline4: Typography.whiteCupertino.headline4!.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF17181A),
      ),

      // [已修订]
      headline5: Typography.blackCupertino.headline5!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: const Color(0xFF17181A),
      ),

      /// 灰色字体
      bodyText1: Typography.blackCupertino.bodyText1!.copyWith(
        color: const Color(0xFF8F959E),
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.41,
      ),

      /// 深色字体
      bodyText2: Typography.blackCupertino.bodyText2!.copyWith(
        color: const Color(0xFF1F2125),
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.41,
      ),
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(btnBorderRadius)),
    ),
    tooltipTheme: const TooltipThemeData(
        verticalOffset: 16,
        decoration: BoxDecoration(
            color: Color(0xCC000000),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 12,
        )),
    disabledColor: const Color(0xFF8F959E),
    errorColor: const Color(0xFFF24848));

const webIconColor = Color(0x5F717D8D);
final webBorderDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: Colors.white,
    boxShadow: const [
      BoxShadow(
          blurRadius: 26,
          spreadRadius: 7,
          offset: Offset(0, 7),
          color: Color(0x1F717D8D))
    ]);
