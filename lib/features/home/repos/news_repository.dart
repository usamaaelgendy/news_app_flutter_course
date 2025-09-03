import 'package:news_app/core/datasource/remote_data/api_config.dart';
import 'package:news_app/core/datasource/remote_data/api_service.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

abstract class BaseNewsRepository {
  Future<List<NewsArticleModel>> getTopHeadLine({String? selectedCategory = "general"});

  Future<List<NewsArticleModel>> getEverything();
}

class NewsRepository extends BaseNewsRepository {
  @override
  Future<List<NewsArticleModel>> getTopHeadLine({String? selectedCategory = "general"}) async {
    Map<String, dynamic> result = await ApiService().get(
      ApiConfig.topHeadlines,
      params: {"country": "us", "category": selectedCategory},
    );

    return (result["articles"] as List).map((e) => NewsArticleModel.fromJson(e)).toList();
  }

  @override
  Future<List<NewsArticleModel>> getEverything() async {
    Map<String, dynamic> result = await ApiService().get(ApiConfig.everything, params: {"q": "news"});

    return (result["articles"] as List).map((e) => NewsArticleModel.fromJson(e)).toList();
  }
}