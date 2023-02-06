// import 'dart:io';
//
// import 'package:flutter/widgets.dart' hide MenuItem;
// import 'package:get/get.dart';
// import 'package:path/path.dart' as p;
// import 'package:system_tray/system_tray.dart';
// import 'package:window_size/window_size.dart' as window_size;
//
// class WindowSize {
//   static const double windowWidth = 1280;
//   static const double windowHeight = 720;
//   static const double minScale = 0.8;
//
//   static Future<void> initialize() async {
//     const minWidth = windowWidth * minScale;
//     const minHeight = windowHeight * minScale;
//     window_size.setWindowMinSize(const Size(minWidth, minHeight));
//   }
// }
//
// class WindowTray {
//   static final SystemTray _systemTray = SystemTray();
//   static final AppWindow _appWindow = AppWindow();
//   // 从托盘关闭App
//   static void exitApp() {
//     _appWindow.close();
//   }
//   // 激活fanbook窗口
//   static void activeWindow() {
//     _appWindow.show();
//   }
//
//   static Future<void> initSystemTray() async {
//     String path;
//     if (Platform.isWindows) {
//       path = p.joinAll([
//         p.dirname(Platform.resolvedExecutable),
//         'data/flutter_assets/assets',
//         'app-icon/icon.ico'
//       ]);
//     } else if (Platform.isMacOS) {
//       path = p.joinAll(['AppIcon']);
//     } else {
//       return;
//     }
//
//     await _systemTray.initSystemTray("Fanbook",
//         iconPath: path, toolTip: "Fanbook");
//     await _systemTray.setContextMenu(
//       [
//         MenuItem(
//           label: '打开Fanbook'.tr,
//           onClicked: () {
//             _appWindow.show();
//           },
//         ),
//         MenuSeparator(),
//         MenuItem(
//           label: '退出Fanbook',
//           onClicked: () {
//             _appWindow.close();
//           },
//         ),
//       ],
//     );
//
//     _systemTray.registerSystemTrayEventHandler((eventName) {
//       if (eventName == "leftMouseUp") {
//         _appWindow.show();
//       }
//     });
//   }
// }
