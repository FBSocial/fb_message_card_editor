import 'package:flutter/foundation.dart';

class TimeMeasurer {
  static DateTime start() {
    return DateTime.now();
  }

  static void end(String info, DateTime startPoint) {
    debugPrint(
        "[Time Measurer] $info, ${DateTime.now().difference(startPoint).inMilliseconds}ms elapsed");
  }
}
