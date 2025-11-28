import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/core/datasource/remote_data/api_config.dart';

abstract class BaseApiService {
  Future<dynamic> get(String endpoint, String baseUrl, {Map<String, dynamic>? params});

  Future<dynamic> post(String endpoint, String baseUrl, {Map<String, dynamic>? body});
}

class ApiService extends BaseApiService {
  @override
  Future<dynamic> get(
    String endpoint,
    String baseUrl, {
    Map<String, dynamic>? params,
  }) async {
    var url = Uri.http(baseUrl, "v2/$endpoint", {"apiKey": ApiConfig.apiKey, ...?params});

    try {
      final http.Response response = await http.get(
        url,
        headers: {"accept": "application/json"},
      );

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Failed To load Data");
    }
  }

  @override
  Future<dynamic> post(
    String endpoint,
    String baseUrl, {
    Map<String, dynamic>? body,
  }) async {
    var url = Uri.https(baseUrl, endpoint);

    print(url);

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          "accept": "application/json" ,
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Failed To load Data");
    }
  }
}
