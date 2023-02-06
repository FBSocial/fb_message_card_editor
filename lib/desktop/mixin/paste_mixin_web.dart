// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;
//
// import 'package:flutter/material.dart';
// import 'package:im/desktop/widgets/send_image/send_image_dialog.dart';
// import 'package:im/pages/home/view/bottom_bar/web_bottom_bar.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
//
// typedef WebImageSendCallback = Function(Asset);
// mixin WebOnPasteMixin on State<WebBottomBar> {
//   WebImageSendCallback sendCallback;
//
//   // ignore: type_annotate_public_apis
//   Future<void> onPaste(event) async {
//     if (!mounted) return;
//     if (!FocusScope.of(context).hasFocus) return;
//     if (event.clipboardData.files.isEmpty) return;
//     final file = event.clipboardData.files.first;
//     final filepath = html.Url.createObjectUrlFromBlob(file);
//     final res = await showImageDialog(
//         context, XFile(filepath, name: file.name, length: file.size));
//     sendCallback?.call(res);
//   }
//
//   void addWebPasteListener(WebImageSendCallback cb) {
//     sendCallback = cb;
//     html.window.document.addEventListener('paste', onPaste);
//   }
//
//   void removeWebPasteListener() {
//     html.window.document.removeEventListener('paste', onPaste);
//   }
// }
