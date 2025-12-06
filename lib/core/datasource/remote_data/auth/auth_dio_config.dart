import 'package:dio/dio.dart';
import 'package:news_app/core/datasource/remote_data/auth/auth_api_config.dart';
import 'package:news_app/core/datasource/remote_data/interceptors/auth_interceptor.dart';

import '../interceptors/logging_interceptor.dart';

class AuthDioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AuthApiConfig.authBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {"accept": "application/json", "Content-Type": "application/json"},
      ),
    );

    dio.interceptors.addAll([AuthInterceptor(), LoggingInterceptor()]);

    return dio;
  }
}
