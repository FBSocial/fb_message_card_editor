import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:lib_net/lib_net.dart';
import 'package:lib_net/src/interceptors/header_interceptor.dart';
import 'package:lib_net/src/interceptors/signature_interceptor.dart';
import 'package:lib_net/src/response.dart';

import 'token_manager.dart';

const _appSecret = "PvDPw9970JZtdY0H0nR0";
const _appKey = "HkFMtgKxPX0RvwnrYb8O";
const timeOut = Duration(seconds: 15);

/// Fanbook 服务业务错误，发生在网络请求成功，但是业务逻辑失败的情况下
class HttpBusinessError implements Exception {
  final int code;
  final String message;

  HttpBusinessError(this.code, this.message);

  @override
  String toString() => '[$code] $message';
}

class SuperProperties {
  final String platform;
  final String channel;
  final String version;
  final String systemName;
  final String? deviceId;
  final String buildNumber;

  SuperProperties({
    required this.platform,
    required this.channel,
    required this.version,
    required this.systemName,
    required this.deviceId,
    required this.buildNumber,
  });

  @override
  String toString() => "platform:$platform;channel:$channel;version:$version;";
}

class Http {
  static const String kOptionErrorToast = "errorToast";

  /// 最佳实践 toast 不应该与 Http 发生耦合，但 fanbook 服务端数据除了 http 自身的 code 外，还在 body 的最外层加了一层 code 和 message
  /// 因此，是否显示错误还需要依赖于业务逻辑判断，如果在拦截器内实现，要再次反序列化 body，和判断错误码，为了避免此开销，将此功能交给 Http 业务层实现
  /// 但是为了尽可能避免与 UI 的耦合，将以回调方式暴露接口
  static void Function(String message)? errorToaster;

  static Dio? dio;

  /// Fanbook 的 token 续期仅发生在登入时，没有 token 过期的自动续期，因此 token 的维护不需要放在拦截器内
  static late TokenManager tokenManger = TokenManager();

  static void reinitialize({
    required Env env,
    String? proxy,
    required SuperProperties superProperties,
  }) {
    HttpConfig.env = env;

    dio?.close(force: true);
    dio = Dio();
    dio!.options
      ..baseUrl = HttpConfig.host
      ..headers = {
        HttpHeaders.userAgentHeader: superProperties.toString(),
      };

    dio!.options
      ..responseType = ResponseType.json
      ..sendTimeout = timeOut.inMilliseconds
      ..receiveTimeout = timeOut.inMilliseconds
      ..connectTimeout = timeOut.inMilliseconds;

    if (proxy != null) {
      setProxy(dio!, proxy);
    }

    tokenManger.retrieveTokenFromLocal();

    dio!.interceptors
      ..add(SignatureInterceptor(appSecret: _appSecret, appKey: _appKey))
      ..add(HeaderInterceptor(superProperties))
      ..add(RetryInterceptor(dio: dio!, options: RetryOptions.noRetry()));
  }

  /// 请求成功，并且业务逻辑处理成功，会触发 [onSuccess]，否则会触发 [onFail]，注意 [onFail] 仅在服务端返回业务逻辑失败的情况下触发
  /// 如果请求失败，例如网络异常，不会触发 [onFail]，如果不关心是业务失败还是网络异常，可以在 Future 完成后判断是否有 [Exception]
  /// 如果希望无论成功还是失败，都执行一些逻辑，可以在 Future 完成后执行，此 Future 不会触发任何异常
  static Future<Exception?> post(String path,
      // ignore: avoid_annotating_with_dynamic
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      // ignore: avoid_annotating_with_dynamic
      Function(dynamic)? onSuccess,
      Function(int errCode, String errMsg)? onFail}) async {
    // 决定如果网络错误是否要弹出 toast 提示，这个行为被混入到业务逻辑里，并且无法拆分成拦截器的原因是：
    // fanbook 服务端除了 http 自身的 code 外，还在 body 的最外层加了一层 code 和 message
    // 因此，是否显示错误还需要解析
    final showErrorToast =
        errorToaster != null && (options?.extra?['errorToast'] ?? false);
    try {
      final resp = await dio!.post(
        path,
        data: data?.toJson(),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      // check http status
      if (resp.statusCode! >= 200 && resp.statusCode! < 300) {
        final fbResp = FbResponse.fromJson(resp.data);
        // check fanbook server status
        if (fbResp.code == 1000) {
          if (onSuccess != null) onSuccess(fbResp.data);
          return null;
        } else {
          if (onFail != null) onFail(0, fbResp.desc);
          if (showErrorToast) errorToaster!(fbResp.desc);
          return HttpBusinessError(fbResp.code, fbResp.desc);
        }
      } else {
        if (onFail != null) onFail(resp.statusCode!, resp.statusMessage!);
        if (showErrorToast) errorToaster!(resp.statusMessage!);
        return HttpBusinessError(resp.statusCode!, resp.statusMessage!);
      }
    } on DioError catch (e) {
      if (showErrorToast) {
        if (e.type == DioErrorType.response) {
          errorToaster!("数据异常，请重试！");
        } else if (e.type != DioErrorType.cancel) {
          /// 当异常类型为DioErrorType.cancel时为代码中主动取消请求，为正常业务逻辑，不弹toast提示,其他情况提示网络质量问题
          errorToaster!("网络质量不佳，请稍后重试");
        }
      }
      log("[${e.type} ${e.response?.statusCode}] request $path failed with message ${e.response?.statusMessage}",
          name: "Http");
      return e;
    } catch (e) {
      if (showErrorToast) {
        errorToaster!("数据异常，请重试！");
      }
      if (e is Exception) return e;
      if (e is Error) return Exception(e.toString());
      rethrow;
    }
  }

  static void setProxy(Dio dio, String? proxy) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        return "PROXY $proxy";
      };
      // 需要校验所有证书：只有有效的根证书才能被信任。
      // CA颁发的证书，被系统成功认证的话，不会走到这个回调；没有成功认证会走到这里。直接返回false,拒绝这些情况的请求。
      // 我们的证书是CA颁发的，被系统认证的。因此能够正常访问。
      client.badCertificateCallback = (cert, host, port) {
        // return false;
        return true;
      };
      return null;
    };
  }
}
