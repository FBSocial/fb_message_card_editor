// ignore: unused_import
import 'dart:typed_data';

import 'package:multi_image_picker/multi_image_picker.dart';

import 'web_util_web.dart' if (dart.library.io) 'web_util_window.dart';

class WebConfig {
  static bool preventDefault = false;
  static bool isWindowHidden = false;
  static void disableContextMenu() {
    preventDefault = true;
  }
}

final webUtil = WebUtil();

abstract class WebUtilBase {
  void downloadFile(String url);

  String getHref();

  void initNotification();

  void pushLocalNotification(
      String title, String body, Map<String, String> extra);

  void setBadge(int badge);

  void callJsMethod(String methodName, List<dynamic> params);

  // ignore: type_annotate_public_apis
  Future<Uint8List> createUnit8ListFromFile(file);

  // ignore: type_annotate_public_apis
  Future<String> createBlobUrlFromFile(file);

  // ignore: type_annotate_public_apis
  Future<Asset> getAssetInfo(file);

  // ignore: type_annotate_public_apis
  Future<Asset> getImageInfo(file);

  // ignore: type_annotate_public_apis
  Future<Asset> getVideoInfo(file);

  // ignore: type_annotate_public_apis
  Future<Uint8List> compressImageFromElement(String blobPath,
      {double quality = 0.6});

  void setCookie(String key, String value,
      {String domain, String path, bool secure, int expires});

  String getCookie(String key);

  void refreshHtml();

  void wakeUpApp(String postId, String topicId) {}

  String gzip(Uint8List bytes);
}
