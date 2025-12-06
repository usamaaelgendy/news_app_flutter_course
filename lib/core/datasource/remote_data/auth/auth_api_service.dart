import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/core/datasource/local_data/user_repository.dart';

abstract class AuthBaseApiService {
  Future<dynamic> post(String endpoint, String baseUrl, {Map<String, dynamic>? body});
}

class AuthApiService extends AuthBaseApiService {
  @override
  Future<dynamic> post(
    String endpoint,
    String baseUrl, {
    Map<String, dynamic>? body,
  }) async {
    var url = Uri.https(baseUrl, endpoint);

    final Map<String, String> headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
    };

    final token = UserRepository().getUser()?.accessToken;
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    try {
      final http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        throw Exception(responseBody["message"] ?? "Failed To load Data");
      }
    } catch (e) {
      throw Exception("Failed To load Data");
    }
  }
}
