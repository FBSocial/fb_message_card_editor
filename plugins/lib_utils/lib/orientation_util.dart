import 'package:flutter/widgets.dart';
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/universal_platform.dart';

/// 决定是横屏还是竖屏
/// 由于 Orientation 是根据宽高判断的，但是我们不希望在 PC 或者 Web 上看到竖屏
/// 在 PC 和 Web 上 portrait 始终是 false，landscape 为 true
///
/// app（ios、android）移动端浏览器   竖屏模式
// mac、windows桌面端、pc端浏览器  横屏模式
// ipad app 采用横屏模式，禁用竖屏模式
// ipad web 采用横屏模式，横向超出滚动
class OrientationUtil {
  static bool get portrait {
    if (UniversalPlatform.isWebMobile) return true;

    if (UniversalPlatform.isMobileDevice) {
      return MediaQuery.of(Config.navigatorKey.currentContext!).orientation ==
          Orientation.portrait;
    }
    return false;
  }

  static bool get landscape => !OrientationUtil.portrait;
}
