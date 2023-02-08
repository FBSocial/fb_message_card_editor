// ignore_for_file: avoid_escaping_inner_quotes

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_net/src/http.dart';
import 'package:lib_net/src/interceptors/signature_interceptor.dart';
import 'package:lib_utils/config/sp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appKey = "HkFMtgKxPX0RvwnrYb8O";
const token =
    "a169e07d91846a31602db66a30c6b1ab56b1c0d055e50f628123c4018a27cb24dbc1ec2f1444265a92fd6bb84b9da449884cd6aedb144f9e0c0fa1254de00a00f68458a32069484c356da882cb70e3b211a0f7b85c9f3331ef57c751694b4d18";
final interceptor = SignatureInterceptor(
  appSecret: "PvDPw9970JZtdY0H0nR0",
  appKey: appKey,
);

void main() {
  setUpAll(() async {
    final Map<String, Object> values = <String, Object>{};
    SharedPreferences.setMockInitialValues(values);
    await SpService.instance.ensureInitialized();

    Http.tokenManger.token = token;
  });

  test('signature', () {
    expect(
      interceptor.getSignature({
        "Nonce": "783ee3a6-2b8e-40d9-8860-b545263c9812",
        "Timestamp": "1658404162672",
        "Authorization":
            "a169e07d91846a31602db66a30c6b1ab56b1c0d055e50f628123c4018a27cb24dbc1ec2f1444265a92fd6bb84b9da449884cd6aedb144f9e0c0fa1254de00a00f68458a32069484c356da882cb70e3b211a0f7b85c9f3331ef57c751694b4d18",
        "AppKey": "HkFMtgKxPX0RvwnrYb8O",
        "RequestBody":
            "{\"user_id\":\"86654728397791232\",\"transaction\":\"AWUfHJvRPSww\"}"
      }),
      "e7a0cd9ddffcd8b1bb8ce82469c2142b",
    );
  });

  test('签名不影响 GET 请求', () {
    final options = RequestOptions(path: '/foo', method: "GET");
    interceptor.onRequest(options, RequestInterceptorHandler());
    expect(options.headers.length, 1, reason: "只应该有一个默认的 content-type");
  });

  test('签名将对 POST 请求生效', () {
    final options = RequestOptions(path: '/foo', method: "POST", data: {
      "foo": "bar",
    });
    interceptor.onRequest(options, RequestInterceptorHandler());
    expect(options.headers['content-type'], "application/json; charset=utf-8");
    expect(options.headers.containsKey('Nonce'), true);
    expect(int.parse(options.headers['Timestamp']),
        lessThan(DateTime.now().millisecondsSinceEpoch));
    expect(options.headers['Authorization'], token);
    expect(options.headers['AppKey'], appKey);
    expect(options.headers.containsKey('signature'), true);
  });
}
