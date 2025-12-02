import 'package:dio/dio.dart';

class DioConfig {
  static Dio createDio() {
    return Dio(
      BaseOptions(
        baseUrl: "https://dummyjson.com/",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {"accept": "application/json", "Content-Type": "application/json"},
      ),
    );
  }
}
