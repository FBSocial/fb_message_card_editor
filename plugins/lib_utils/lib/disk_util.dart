import 'package:disk_space/disk_space.dart';
import 'package:flutter/foundation.dart';

class DiskUtil {
  /// 设备储存空间大于 [spaceInMb] 时，返回 true，空间不足时返回 false
  /// 如果处于 Web 平台，视为空间足够，返回 true
  static Future<bool> availableSpaceGreaterThan(double spaceInMb) {
    // Web 视为空间够用
    if (kIsWeb) return Future.value(true);

    return DiskSpace.getFreeDiskSpace.then((value) {
      return value! > spaceInMb;
    }).catchError((_) => true);
  }
}
