import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lib_net/lib_net.dart';
import 'package:lib_utils/config/config.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor(this.superProperties);

  final SuperProperties superProperties;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final headerMap = {
      'platform': superProperties.platform,
      'version': superProperties.version,
      'channel': superProperties.channel,
      'systemName': superProperties.systemName,
      'device_id': superProperties.deviceId ?? '',
      'build_number': superProperties.buildNumber,
      'uuid': Config.webUUid
    };

    final jsonString = jsonEncode(headerMap);
    final content = utf8.encode(jsonString);
    final base64String = base64Encode(content);

    // 语言标识符
    final languageCode =
        '${Get.locale!.languageCode}_${Get.locale!.countryCode}';

    options.headers.addAll({
      'x-super-properties': base64String,
      'language': languageCode,
    });

    super.onRequest(options, handler);
  }
}
