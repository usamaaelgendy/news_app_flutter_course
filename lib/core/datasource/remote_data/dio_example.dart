import 'package:dio/dio.dart';
import 'package:news_app/core/datasource/remote_data/dio_config.dart';

class DioExample {
  static final dio = DioConfig.createDio();

  static Future<void> exampleGetRequest() async {
    try {
      await dio.get("products");
    } catch (e) {}
  }

  static Future<void> exampleGetRequestWithQueryParameter() async {
    await dio.get("products/search", queryParameters: {"q": "phone"});
  }

  static Future<void> examplePostRequest() async {
    await dio.post("products/add", data: {"title": "adsdasdasd"});
  }

  static Future<void> examplePutRequest() async {
    await dio.put("products/1", data: {"title": 'iPhone Galaxy +1'});
  }

  static Future<void> exampleDeleteRequest() async {
    await dio.delete("products/1");
  }

  static Future<void> exampleErrorHandling() async {
    try {
      await dio.post("lfnal;ksnflsaknflkasn;fsalnf");
    } on DioException catch (e) {
      print("Error ${e.type}");
      print("Error ${e.message}");
      print("Error ${e.response?.statusCode}");

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw "Connection timeout";
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
        case DioExceptionType.cancel:
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          throw e.message.toString();
      }
    }
  }
}
