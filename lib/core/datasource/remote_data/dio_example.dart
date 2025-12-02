import 'package:dio/dio.dart';
import 'package:news_app/core/datasource/remote_data/dio_config.dart';

class DioExample {
  static Future<void> exampleGetRequest() async {
    try {
      final dio = DioConfig.createDio();

      final response = await dio.get("products");

      print(response.data);
    } catch (e) {}
  }

  static Future<void> exampleGetRequestWithQueryParameter() async {
    final dio = Dio(BaseOptions());
  }
}
