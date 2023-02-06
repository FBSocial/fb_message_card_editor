import 'package:dio/dio.dart';

class MutexOption {
  static const extraKey = "channel_mutex_options";

  MutexOption();

  static MutexOption? fromExtra(RequestOptions request) {
    return request.extra[extraKey];
  }

  Map<String, dynamic> toExtra() {
    return {
      extraKey: this,
    };
  }

  Options toOptions() {
    return Options(extra: toExtra());
  }
}

class MutexInterceptor extends Interceptor {
  final Map<MutexOption, CancelToken?> _map = {};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final option = MutexOption.fromExtra(options);
    if (option == null) {
      return super.onRequest(options, handler);
    }

    if (_map.containsKey(option)) {
      if (_map[option] != options.cancelToken) {
        _map[option]!.cancel();
      }
    }
    _map[option] = options.cancelToken;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final option = MutexOption.fromExtra(response.requestOptions);
    if (option == null) {
      return super.onResponse(response, handler);
    }
    _map.remove(option);
    super.onResponse(response, handler);
  }
}
