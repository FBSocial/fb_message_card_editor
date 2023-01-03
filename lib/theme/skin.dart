import 'package:flutter/material.dart';

import 'default_theme.dart';
import 'web_light_theme.dart';

/// 皮肤管理类
class Skin {
  /// 当前主题
  static DefaultTheme theme = WebLightTheme();

  /// 当前主题数据
  static ThemeData? themeData = theme.themeData;
}
