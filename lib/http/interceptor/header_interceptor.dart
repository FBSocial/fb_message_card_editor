import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fb_message_card_editor/http/Global.dart';
import 'package:get/get.dart';
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/universal_platform.dart';

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    /// app版本号
    final version = Global.packageInfo?.version ?? '';
    final buildNumber = Global.packageInfo?.buildNumber ?? '';

    var channel = Config.channel;
    String platform = '';

    if (UniversalPlatform.isIOS) {
      platform = '0';
    } else if (UniversalPlatform.isAndroid) {
      platform = '1';
    } else if (UniversalPlatform.isWeb) {
      platform = '2';
      channel = 'web';
    } else if (UniversalPlatform.isWindows) {
      platform = '3';
      channel = 'windows';
    } else if (UniversalPlatform.isMacOS) {
      platform = '4';
      channel = 'mac';
    } else if (UniversalPlatform.isLinux) {
      platform = '5';
      channel = 'linux';
    } else if (UniversalPlatform.isFuchsia) {
      platform = '6';
      channel = 'fuchsia';
    }

    final systemName = Global.deviceInfo!.systemName!.toLowerCase();
    final deviceId = Global.deviceInfo!.identifier;

    final headerMap = {
      'platform': platform,
      'version': version,
      'channel': channel,
      'systemName': systemName,
      'device_id': deviceId ?? '',
      'build_number': buildNumber,
      'uuid': Config.webUUid
    };

    final jsonString = jsonEncode(headerMap);
    final content = utf8.encode(jsonString);
    final base64String = base64Encode(content);

    // 语言标识符
    final languageCode = '${Get.locale!.languageCode}_${Get.locale!.countryCode}';

    options.headers.addAll({
      'x-super-properties': base64String,
      'language': languageCode,
    });

    super.onRequest(options, handler);
  }
}
