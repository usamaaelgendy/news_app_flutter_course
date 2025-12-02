

import 'package:dio/dio.dart';

class DioExample {

  static Future<void> exampleGetRequest()async{
    final dio = Dio();

    final response = await dio.get("https://dummyjson.com/products");


    print(response.statusCode);
    print(response.statusMessage);
    print(response.headers);
    print(response.data);

  }
}