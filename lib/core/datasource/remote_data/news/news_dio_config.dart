import 'package:dio/dio.dart';
import 'package:news_app/core/datasource/remote_data/api_config.dart';
import 'package:news_app/core/datasource/remote_data/interceptors/logging_interceptor.dart';

class NewsDioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.newsBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {"accept": "application/json", "Content-Type": "application/json"},
      ),
    );

    dio.interceptors.addAll([LoggingInterceptor()]);

    return dio;
  }
}
