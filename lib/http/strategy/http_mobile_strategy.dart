import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fb_message_card_editor/http/Global.dart';

import 'package:lib_net/lib_net.dart' as net;
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/loggers.dart';


import '../interceptor/channel_mutex_interceptor.dart';
import '../interceptor/header_interceptor.dart';
import '../interceptor/logging_interceptor.dart';
import '../interceptor/token_interceptor.dart';
import 'http_strategy.dart';

class MobileHttpStrategy implements HttpStrategy {
  @override
  void init(Dio dio, int timeOut) {
    dio.interceptors
      ..add(TokenInterceptor())
      ..add(MutexInterceptor())
      // ..add(TextCheckerInterceptor())
      ..add(LoggingInterceptor())
      ..add(HeaderInterceptor())
      ..add(net.RetryInterceptor(
        dio: dio,
        options: net.RetryOptions.noRetry(),
      ));

    ///添加拦截器，开发和测试环境打印http请求详细日志
    final bool show = Config.env == Env.newtest || Config.env == Env.dev;
    if (show) {
      //开发测试环境显示http详细日志
      dio.interceptors
          .add(LogInterceptor(requestBody: show, responseBody: show));
    }

    dio.options.baseUrl = Config.host;
    dio.options
      ..responseType = ResponseType.json
      ..sendTimeout = timeOut * 1000
      ..receiveTimeout = timeOut * 1000
      ..connectTimeout = timeOut * 1000;

    ///这里的[deviceInfo]可能尚未初始化完成，导致[channel]的值传入的是默认值，所以需要等待初始化完成
    Global.getDeviceInfo().then((value) {
      dio.options.headers = {
        HttpHeaders.userAgentHeader:
            "platform:${Global.deviceInfo!.systemName!.toLowerCase()};channel:${Config.channel};version:${Global.packageInfo!.version};",
      };
    });
  }

  @override
  Future<Response> post(
      {Dio? dio,
      int? timeOut,
      String? path,
        data,
      CancelToken? cancelToken,
      Options? options}) {
    logger.info('post http path. $path');
    return dio!
        .post(path!, data: data, cancelToken: cancelToken, options: options);
  }

  @override
  Future<Response> put({Dio? dio,
    int? timeOut,
    String? path,
    data,
    CancelToken? cancelToken,
    Options? options}) {
    return dio!
        .put(path!, data: data, cancelToken: cancelToken, options: options);
  }
}
