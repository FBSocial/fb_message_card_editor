import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:fb_message_card_editor/desktop/utils/share_preferences/share_preference.dart';


class SessionSharePreferenceWeb extends SharedPreferencesSessionImpl {
  static SessionSharePreferenceWeb instance = SessionSharePreferenceWeb();

  @override
  bool clear() {
    // ignore: prefer_foreach
    for (final String key in _storedFlutterKeys) {
      html.window.sessionStorage.remove(key);
    }
    return true;
  }

  @override
  Map<String, Object> getAll() {
    final Map<String, Object> allData = <String, Object>{};
    for (final String key in _storedFlutterKeys) {
      allData[key] = _decodeValue(html.window.sessionStorage[key]!);
    }
    return allData;
  }

  @override
  bool remove(String key) {
    _checkPrefix(key);
    html.window.sessionStorage.remove(key);
    return true;
  }

  @override
  bool setValue(String valueType, String key, Object value) {
    _checkPrefix(key);
    html.window.sessionStorage[key] = _encodeValue(value);
    return true;
  }

  void _checkPrefix(String key) {
    if (!key.startsWith('flutter.')) {
      throw FormatException(
        'Shared preferences keys must start with prefix "flutter.".',
        key,
        0,
      );
    }
  }

  List<String> get _storedFlutterKeys {
    final List<String> keys = <String>[];
    for (final String key in html.window.sessionStorage.keys) {
      if (key.startsWith('flutter.')) {
        keys.add(key);
      }
    }
    return keys;
  }

  String _encodeValue(Object value) {
    return json.encode(value);
  }

  Object _decodeValue(String encodedValue) {
    final Object decodedValue = json.decode(encodedValue);

    if (decodedValue is List) {
      return decodedValue.cast<String>();
    }

    return decodedValue;
  }
}
