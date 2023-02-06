import 'share_preference_session_windows.dart'
    if (dart.library.html) 'share_preference_session.dart';

abstract class SharedPreferencesSessionImpl {
  bool setValue(String valueType, String key, Object value);
  bool remove(String key);
  bool clear();
  Map<String, Object> getAll();
}

/// 仅支持web版本， 用于session 存储
class SessionSharePreference {
  static SessionSharePreferenceWeb sessionManager = SessionSharePreferenceWeb();
  static SessionSharePreference instance = SessionSharePreference();
  late Map<String, Object> _allMap;
  static String keyPrefix = 'flutter.';

  SessionSharePreference() {
    _allMap = SessionSharePreference.sessionManager.getAll();
  }

  void setValue(String valueType, String key, Object value) {
    SessionSharePreference.sessionManager
        .setValue(valueType, '$keyPrefix$key', value);
    if (value == null) {
      _allMap.remove(key);
    } else {
      _allMap[key] = value;
    }
  }

  Object? getValue(String key) {
    return _allMap['$keyPrefix$key'];
  }
  //
  // bool getBool(String key) => getValue(key);
  //
  // int getInt(String key) => getValue(key);
  //
  // double getDouble(String key) => getValue(key);
  //
  // String getString(String key) => getValue(key);

  void setBool(String key, bool value) => setValue('Bool', key, value);

  void setInt(String key, int value) => setValue('Int', key, value);

  void setDouble(String key, double value) => setValue('Double', key, value);

  void setString(String key, String value) => setValue('String', key, value);
}
