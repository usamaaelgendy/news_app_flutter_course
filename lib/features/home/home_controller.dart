import 'package:flutter/cupertino.dart';
import 'package:news_app/core/datasource/remote_data/api_config.dart';
import 'package:news_app/core/datasource/remote_data/api_service.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class HomeController extends ChangeNotifier {
  HomeController() {
    getTopHeadLine();
    getEverything();
  }

  RequestStatusEnum everythingStatus = RequestStatusEnum.loading;

  bool topHeadLineLoading = true;
  String? errorMessage;

  String? selectedCategory;

  List<NewsArticleModel> newsTopHeadLineList = [];
  List<NewsArticleModel> newsEverythingList = [];
  ApiService apiService = ApiService();

  getTopHeadLine({String? category}) async {
    try {
      Map<String, dynamic> result = await apiService.get(
        ApiConfig.topHeadlines,
        params: {"country": "us", "category": selectedCategory},
      );

      newsTopHeadLineList = (result["articles"] as List).map((e) => NewsArticleModel.fromJson(e)).toList();
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
      Map<String, dynamic> result = await apiService.get(ApiConfig.everything, params: {"q": "news"});

      newsEverythingList = (result["articles"] as List).map((e) => NewsArticleModel.fromJson(e)).toList();

      everythingStatus = RequestStatusEnum.loaded;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      everythingStatus = RequestStatusEnum.error;
    }

    notifyListeners();
  }

  void updateSelectedCategory(String category) {
    selectedCategory = category;
    getTopHeadLine(category: selectedCategory);
    notifyListeners();
  }
}
