import 'package:lib_utils/config/sp_service.dart';

/// Fanbook 的 token 续期仅发生在登入时，没有 token 过期的自动续期，因此 token 的维护不需要放在拦截器内
class TokenManager {
  String? _token;

  String? get token => _token;

  set token(String? value) {
    _token = value;
    if (value == null) {
      SpService.instance.remove(SP.token);
      SpService.instance.remove(SP.tokenUpdateTime);
    } else {
      final oldValue = SpService.instance.getString(SP.token);
      if (oldValue != value) {
        SpService.instance.setString(SP.token, value);
        // 保存时间戳
        SpService.instance
            .setInt(SP.tokenUpdateTime, DateTime.now().millisecondsSinceEpoch);
      }
    }
  }

  void retrieveTokenFromLocal() {
    _token = SpService.instance.getString(SP.token);
  }
}
