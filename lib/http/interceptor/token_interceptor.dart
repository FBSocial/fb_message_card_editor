import 'dart:async';

import 'package:dio/dio.dart';

import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/config/sp_service.dart';

import '../../app/modules/login/api/User_Api.dart';


class TokenInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.path == UserApi.updateTokenUrl) {
      final String? token = response.headers['authorization']?.first;
      if (token != null && token.isNotEmpty) {
        // 保存token
        Config.token = token;
        unawaited(SpService.instance.setString(SP.token, token));
        // 保存时间戳
        unawaited(SpService.instance
            .setInt(SP.tokenUpdateTime, DateTime.now().millisecondsSinceEpoch));
      }
    }
    handler.next(response);
  }
}
