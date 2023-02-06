import 'dart:async';

import 'package:dio/dio.dart';

import 'package:lib_net/lib_net.dart' hide UserApi;
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/config/sp_service.dart';


import '../../app/modules/login/api/User_Api.dart';
import '../interceptor/channel_mutex_interceptor.dart';
import '../interceptor/header_interceptor.dart';
import 'http_strategy.dart';

class WebHttpStrategy implements HttpStrategy {
  @override
  void init(Dio dio, int timeOut) {
    dio.interceptors.add(InterceptorsWrapper(onResponse: (res, handler) {
      if (res.requestOptions.path == UserApi.updateTokenUrl) {
        final String? token = res.headers['authorization']?.first;
        if (token != null && token.isNotEmpty) {
          // 保存token
          Config.token = token;
          unawaited(SpService.instance.setString(SP.token, token));
          // 保存时间戳
          unawaited(SpService.instance.setInt(
              SP.tokenUpdateTime, DateTime.now().millisecondsSinceEpoch));
        }
      }
      handler.resolve(res);
    }));

    dio.interceptors
      // ..add(TextCheckerInterceptor())
      ..add(MutexInterceptor())
      ..add(HeaderInterceptor())
      ..add(RetryInterceptor(
        dio: dio,
        options: RetryOptions.noRetry(),
      ));
    dio.options.baseUrl = Config.host;
    dio.options
      ..responseType = ResponseType.json
      ..sendTimeout = timeOut * 1000
      ..receiveTimeout = timeOut * 1000
      ..connectTimeout = timeOut * 1000;
  }

  @override
  Future<Response> post(
      {Dio? dio,
      int? timeOut,
      String? path,
       data,
      CancelToken? cancelToken,
      Options? options}) {
    return dio!
        .post(path!, data: data, cancelToken: cancelToken, options: options)
        .timeout(Duration(seconds: timeOut!));
  }
  @override
  Future<Response> put(
      {Dio? dio,
      int? timeOut,
      String? path,
       data,
      CancelToken? cancelToken,
      Options? options}) {
    return dio!
        .put(path!, data: data, cancelToken: cancelToken, options: options)
        .timeout(Duration(seconds: timeOut!));
  }
}
