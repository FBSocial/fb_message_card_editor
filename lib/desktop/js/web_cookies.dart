// import 'dart:html';

import 'package:fb_message_card_editor/desktop/js/help.dart'
    if (dart.library.html) 'dart:html';
import 'package:lib_utils/config/config.dart';

class WebCookiesUtils {
  static Map<String, String>? cookieMap;

  static Map<String, String>? getMap() {
    final cookie = document.cookie;
    final entity = cookie?.split("; ").map((item) {
      final splite = item.split("=");
      return MapEntry(splite[0], splite[1]);
    });
    cookieMap = Map.fromEntries(entity!);
    return cookieMap;
  }

  static void setCookie(String name, String value) {
    // Map<String, String>? temp = getMap();
    // temp![name] = value;
    final cookie = document.cookie;
    String res = "$cookie;$name=$value";
    document.cookie = res;
  }

  static Future<void> getCookie(String name) async {
    Map<String, String>? temp = await getMap();
    if (temp != null && temp.isNotEmpty && temp.containsKey('token')) {
      Config.token = temp['token'];
    }
  }
}
