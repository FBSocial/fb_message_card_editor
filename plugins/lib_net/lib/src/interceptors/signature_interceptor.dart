import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lib_net/src/http.dart';
import 'package:uuid/uuid.dart';

class SignatureInterceptor extends Interceptor {
  final uuid = const Uuid();
  final String appSecret;
  final String? appKey;

  SignatureInterceptor({
    required this.appSecret,
    this.appKey,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (options.method == 'POST') {
      final nonce = uuid.v4();
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final authorization = Http.tokenManger.token;

      final Map<String, String> signatureMap = {
        'Nonce': nonce,
        'Timestamp': timestamp,
        // 如果未授权需要使用空字符串，否则签名会出错
        'Authorization': authorization ?? '',
        if (appKey != null) "AppKey": appKey!,
      };

      options.headers.addAll(signatureMap);

      if (options.data == null) {
        signatureMap["RequestBody"] = "";
      } else {
        options.data["transaction"] = uuid.v4();
        signatureMap["RequestBody"] = jsonEncode(options.data);
      }

      final signature = getSignature(signatureMap);
      options.headers["signature"] = signature;
    }

    handler.next(options);
  }

  @visibleForTesting
  String getSignature(Map<String, String> signatureMap) {
    final sb = StringBuffer();
    for (final key in (signatureMap.keys.toList()..sort())) {
      sb.write("$key=${signatureMap[key]}&");
    }
    sb.write(appSecret);
    final signature = Uri.encodeComponent(sb.toString());
    return md5.convert(utf8.encode(signature)).toString();
  }
}
