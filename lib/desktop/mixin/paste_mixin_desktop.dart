// // ignore: avoid_web_libraries_in_flutter
// import 'dart:async';
//
// import 'package:cross_file/cross_file.dart';
// import 'package:desktop_pasteboard/desktop_pasteboard.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:im/desktop/widgets/send_image/send_image_dialog.dart';
// import 'package:im/pages/home/model/input_model.dart';
// import 'package:im/pages/home/view/bottom_bar/web_bottom_bar.dart';
// import 'package:im/utils/universal_platform.dart';
// import 'package:mime/mime.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// // ignore: implementation_imports
// import 'package:provider/src/provider.dart';
//
// typedef WebImageSendCallback = Function(Asset);
// mixin WebOnPasteMixin on State<WebBottomBar> {
//   WebImageSendCallback sendCallback;
//
//   void addWebPasteListener(WebImageSendCallback cb) {
//     sendCallback = cb;
//     context.read<InputModel>().textFieldFocusNode.attach(context,
//         onKey: (node, event) {
//       final key = event.logicalKey;
//       //粘贴图片组合键 win(ctrl+v) macOS(command+v)
//       final isCompanionKeyPressed = UniversalPlatform.isMacOS
//           ? event.isMetaPressed
//           : event.isControlPressed;
//       if (event is RawKeyDownEvent &&
//           (isCompanionKeyPressed && key == LogicalKeyboardKey.keyV)) {
//         _handleFilePaste();
//       }
//       return KeyEventResult.ignored;
//     });
//   }
//
//   Future<void> _handleFilePaste() async {
//     final filePaths = await DesktopPasteboard.getPasteboardFilePaths();
//     if (filePaths.isEmpty) return;
//     final filePath = filePaths[0];
//     final result = await showImageDialog(
//         context, XFile(filePath, mimeType: lookupMimeType(filePath)));
//     if (result == null) return;
//     sendCallback?.call(result);
//   }
//
//   void removeWebPasteListener() {
//     sendCallback = null;
//   }
// }
