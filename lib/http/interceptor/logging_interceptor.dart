import 'package:dio/dio.dart';
import 'package:lib_utils/loggers.dart';


class LoggingInterceptor extends Interceptor {
  final Map<String, DateTime> _map = {};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final String? nonce = options.headers['Nonce'];
    if (nonce != null) {
      _map[nonce] = DateTime.now();
    }
    // LoggerPage.net(options.path, data: options.data);
    logger.fine("[HTTP] ${options.path} start");
    super.onRequest(options, handler);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    final String? nonce = err.requestOptions.headers['Nonce'];
    final DateTime? t = nonce == null ? null : _map[nonce];
    final diffStr =
        t == null ? '' : 'in ${DateTime.now().difference(t).inMilliseconds}ms';
    logger.fine("[HTTP] ${err.requestOptions.path} error $diffStr");

    // LoggerPage.endNet(err.requestOptions.path, status: 400);
    super.onError(err, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final String? nonce = response.requestOptions.headers["Nonce"];
    final DateTime? t = nonce == null ? null : _map[nonce];
    final diffStr =
        t == null ? '' : 'in ${DateTime.now().difference(t).inMilliseconds}ms';
    logger.fine("[HTTP] ${response.requestOptions.path} done $diffStr");

    // LoggerPage.endNet(response.requestOptions.path,
    //     data: response.data,
    //     headers: response.headers,
    //     status: response.statusCode);
    super.onResponse(response, handler);
  }
}
