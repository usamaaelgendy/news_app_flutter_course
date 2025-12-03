import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("BaseUrl = ${options.baseUrl}");
    log("Path = ${options.path}");
    log("Uri = ${options.uri}");
    log("Method = ${options.method}");

    if (options.queryParameters.isNotEmpty) {
      log("QueryParameters = ${options.queryParameters}");
    }

    if (options.data != null) {
      log("Body = ${options.data}");
    }

    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    log("Response = ${response.data}");
    log("StatusCode = ${response.statusCode}");
    log(response.requestOptions.path);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("BaseUrl = ${err.requestOptions.baseUrl}");
    log("Path = ${err.requestOptions.path}");
    log("Uri = ${err.requestOptions.uri}");
    log("Method = ${err.requestOptions.method}");

    if (err.requestOptions.queryParameters.isNotEmpty) {
      log("QueryParameters = ${err.requestOptions.queryParameters}");
    }

    if (err.requestOptions.data != null) {
      log("Body = ${err.requestOptions.data}");
    }

    log("Error");

    print("Type ${err.type}");
    print("Message ${err.message}");
    print("StatusCode ${err.response?.statusCode}");

    handler.next(err);
  }
}
