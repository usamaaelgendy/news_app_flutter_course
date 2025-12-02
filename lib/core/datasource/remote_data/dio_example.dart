import 'package:dio/dio.dart';
import 'package:news_app/core/datasource/remote_data/dio_config.dart';

class DioExample {
  static final dio = DioConfig.createDio();

  static Future<void> exampleGetRequest() async {
    try {
      final response = await dio.get("products");

      print(response.data);
    } catch (e) {}
  }

  static Future<void> exampleGetRequestWithQueryParameter() async {
    final response = await dio.get("products/search", queryParameters: {"q": "phone"});

    print("exampleGetRequestWithQueryParameter");
    print(response.data);
  }

  static Future<void> examplePostRequest() async {
    final response = await dio.post("products/add", data: {"title": "adsdasdasd"});

    print("examplePostRequest");
    print(response);
  }

  static Future<void> examplePutRequest() async {
    final response = await dio.put("products/1", data: {"title": 'iPhone Galaxy +1'});

    print("examplePutRequest");
    print(response);
  }

  static Future<void> exampleDeleteRequest() async {
    final response = await dio.delete("products/1");

    print("exampleDeleteRequest");
    print(response);
  }

  static Future<void> exampleErrorHandling() async {
    try {
      final response = await dio.post("lfnal;ksnflsaknflkasn;fsalnf");

      print("exampleErrorHandling");
      print(response);
    } on DioException catch (e) {
      print("Error ${e.type}");
      print("Error ${e.message}");
      print("Error ${e.response?.statusCode}");

      switch(e.type){
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
