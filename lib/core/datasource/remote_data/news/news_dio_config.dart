import 'package:dio/dio.dart';
import 'package:news_app/core/datasource/remote_data/interceptors/logging_interceptor.dart';
import 'package:news_app/core/datasource/remote_data/news/news_api_config.dart';

class NewsDioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: NewsApiConfig.newsBaseUrl,
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
