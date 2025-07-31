import 'package:flutter/cupertino.dart';
import 'package:news_app/core/datasource/remote_data/api_config.dart';
import 'package:news_app/core/datasource/remote_data/api_service.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class HomeController extends ChangeNotifier {
  HomeController() {
    getTopHeadLine();
    getEverything();
  }

  bool topHeadLineLoading = true;
  bool everythingLoading = true;
  String? errorMessage;

  List<NewsArticleModel> newsTopHeadLineList = [];
  List<NewsArticleModel> newsEverythingList = [];
  ApiService apiService = ApiService();

  getTopHeadLine() async {
    try {
      Map<String, dynamic> result = await apiService.get(
        ApiConfig.topHeadlines,
        params: {"country": "us"},
      );

      newsTopHeadLineList =
          (result["articles"] as List)
              .map((e) => NewsArticleModel.fromJson(e))
              .toList();
      topHeadLineLoading = false;
      errorMessage = null;
    } catch (e) {
      topHeadLineLoading = false;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  getEverything() async {
    try {
      Map<String, dynamic> result = await apiService.get(
        ApiConfig.everything,
        params: {"q": "news"},
      );

      newsEverythingList =
          (result["articles"] as List)
              .map((e) => NewsArticleModel.fromJson(e))
              .toList();

      everythingLoading = false;
      errorMessage = null;
    } catch (e) {
      everythingLoading = false;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}
