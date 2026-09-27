import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/core/datasource/remote_data/api_config.dart';

abstract class BaseApiService {
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params});
}

class ApiService extends BaseApiService {

  @override
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    if (ApiConfig.apiKey.isEmpty) {
      throw Exception(
        "NEWS_API_KEY is missing. Run: flutter run --dart-define-from-file=env.json (see README)",
      );
    }

    var url = Uri.https(ApiConfig.baseUrl, "v2/$endpoint", {"apiKey": ApiConfig.apiKey, ...?params});

    // Log the request without the API key.
    print(url.replace(queryParameters: {...url.queryParameters}..remove("apiKey")));
    try {
      final http.Response response = await http.get(url);

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Failed To load Data");
    }
  }
}
