import 'package:dio/dio.dart';
import 'package:news_app/core/datasource/remote_data/news/news_api_config.dart';

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters['apiKey'] = NewsApiConfig.apiKey;
    handler.next(options);
  }
}
