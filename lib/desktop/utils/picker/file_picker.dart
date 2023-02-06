// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:fb_message_card_editor/http/Global.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
//
// import 'package:image_picker/image_picker.dart';
// import 'package:x_picker/x_picker.dart';
//
// export 'package:image_picker/image_picker.dart' show XFile;
//
// class DesktopAndWebPicker {
//   static XPicker picker = XPicker.instance;
//
//   static final mediasType = imageType + videoType;
//   static final videoType = ["mp4", "avi", "wmv", "rmvb", "mpg", "mpeg", "3gp"];
//   static final imageType = ["gif", "jpg", "jpeg", "png", "bmp", "webp"];
//
//   static Future<String> getDirectoryPath() async {
//     return picker.getDirectoryPath(dialogTitle: "另存为");
//   }
//
//   static Future<List<XFile>> pickFile() async {
//     return pickFiles(allowMultiple: false);
//   }
//
//   static Future<List<XFile>> pickFiles({bool allowMultiple = true}) async {
//     return picker.pickFiles(
//       dialogTitle: "打开",
//       allowMultiple: allowMultiple,
//       type: FileType.any,
//     );
//   }
//
//   static Future<List<XFile>> pickMedia() async {
//     return pickMedias(allowMultiple: false);
//   }
//
//   static Future<List<XFile>> pickMedias(
//       {bool allowMultiple = true, FileType type = FileType.custom}) async {
//     return picker.pickFiles(
//       dialogTitle: "打开",
//       allowMultiple: allowMultiple,
//       type: type,
//       allowedExtensions: mediasType,
//     );
//   }
//
//   static Future<XFile> pickImage(
//       {bool crop = false, CropConfig cropConfig}) async {
//     final picks = await pickImages(allowMultiple: false);
//     XFile pick;
//     if (picks != null && picks.isNotEmpty) pick = picks[0];
//     if (pick != null && crop) {
//       return toCrop(pick, cropConfig: cropConfig);
//     }
//     return pick;
//   }
//
//   static Future<List<XFile>> pickImages({bool allowMultiple = true}) async {
//     final picks = picker.pickFiles(
//       dialogTitle: "打开",
//       allowMultiple: allowMultiple,
//       type: FileType.custom,
//       allowedExtensions: imageType,
//     );
//     return picks;
//   }
//
//   static Future<XFile> toCrop(XFile file, {CropConfig cropConfig}) async {
//     final dir = Directory(
//         "${Directory.systemTemp.path}${Platform.pathSeparator}social");
//     if (!dir.existsSync()) {
//       await dir.create();
//     }
//
//     final fileByte = await file.readAsBytes();
//     final cropFileByte = await Navigator.push(
//         Global.navigatorKey.currentContext, MaterialPageRoute<Uint8List>(
//       builder: (context) {
//         return ImageCropperPage(fileByte, config: cropConfig ?? CropConfig());
//       },
//     ));
//
//     if (cropFileByte != null) {
//       final cropFileName = "crop_${file.name}";
//       final cropFile = File("${dir.path}\\$cropFileName");
//       await cropFile.writeAsBytes(cropFileByte);
//
//       return XFile(cropFile.path,
//           mimeType: file.mimeType,
//           name: cropFileName,
//           length: cropFile.lengthSync(),
//           bytes: await cropFile.readAsBytes(),
//           lastModified: DateTime.now());
//     }
//     return null;
//   }
// }
