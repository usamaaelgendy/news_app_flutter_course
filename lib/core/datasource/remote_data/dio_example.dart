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
}
