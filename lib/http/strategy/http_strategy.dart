import 'package:dio/dio.dart';

abstract class HttpStrategy {
  void init(Dio dio, int timeOut);

  Future<Response> post(
      {Dio? dio,
      int? timeOut,
      String? path,
        data,
      CancelToken? cancelToken,
      Options? options});

  Future<Response> put(
      {Dio? dio,
      int? timeOut,
      String? path, data,
      CancelToken? cancelToken,
      Options? options});

}
