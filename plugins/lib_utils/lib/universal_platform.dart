import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class UniversalPlatform {
  static bool get isWebMobile {
    if (!kIsWeb) return false;
    final pattern = RegExp("iPhone|iPad|iPod|Android", caseSensitive: false);
    return pattern.hasMatch(html.window.navigator.userAgent);
  }

  static String get operatingSystem =>
      kIsWeb ? "web" : Platform.operatingSystem;

  static bool get isWeb => kIsWeb;

  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  static bool get isWindows => !kIsWeb && Platform.isWindows;

  static bool get isIOS => !kIsWeb && Platform.isIOS;

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isFuchsia => !kIsWeb && Platform.isFuchsia;

  static bool get isLinux => !kIsWeb && Platform.isLinux;

  static bool get isPc => isMacOS || isWindows || isLinux;

  static bool get isMobileDevice => isIOS || isAndroid;

  /// - 获取当前平台
  /// - 1:android,2:ios,3:web,4:小程序，5：win pc，6：linux pc 7：Mac pc
  static int clientType() {
    if (isMobileDevice && isWeb) {
      return 4;
    } else if (isAndroid) {
      return 1;
    } else if (isIOS) {
      return 2;
    } else if (isWeb) {
      return 3;
    } else if (isWindows) {
      return 5;
    } else if (isLinux) {
      return 6;
    } else if (isMacOS) {
      return 7;
    }
    return -1;
  }
}
