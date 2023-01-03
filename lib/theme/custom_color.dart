import 'package:flutter/material.dart';

class CustomColor {
  final BuildContext context;
  bool isDart;

  CustomColor(this.context) : isDart = false;

  static final pinBackgroundColor = const Color(0xFFF2AA19).withOpacity(0.06);
  static const red = Color(0xFFF24848);
  static const fontGrey = Color(0xFFD9D9D9);
  static const grey = Color(0xFF787F8D);
  static const orange = Color(0xFFFF6040);
  static const collect = Color(0xFFF2AA19);

  /// 不可以颜色
  Color get disableColor => const Color(0xFF8F959E);

  /// 通用背景颜色
  Color get globalBackgroundColor3 =>
      isDart ? const Color(0xFF363940) : const Color(0xFFF2F3F5);

  Color get globalBackgroundColor4 =>
      isDart ? const Color(0xFF2E3137) : Colors.white;

  /// 特殊背景色
  Color get backgroundColor1 =>
      isDart ? const Color(0xFF1F2125) : const Color(0xFFE0E2E6);

  Color get backgroundColor2 => isDart ? const Color(0xFF2B2E33) : Colors.white;

  Color get backgroundColor3 => isDart ? const Color(0xFF1B1D20) : Colors.white;

  Color get backgroundColor4 =>
      isDart ? const Color(0xFF363940) : const Color(0xFFE0E2E6);

  Color get backgroundColor5 => isDart ? const Color(0xFF27292E) : Colors.white;

  /// 用在对话框中
  Color get backgroundColor6 => isDart ? const Color(0xFF1F2125) : Colors.white;

  Color get backgroundColor7 =>
      isDart ? const Color(0xFF2B2E33) : const Color(0xFFF2F3F5);

  Color get backgroundColor8 => isDart ? const Color(0xFF363940) : Colors.white;
}
