import 'package:flutter/cupertino.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/home/repos/news_repository.dart';

class HomeController extends ChangeNotifier {
  HomeController(this.newsRepository) {
    getTopHeadLine();
    getEverything();
  }

  RequestStatusEnum everythingStatus = RequestStatusEnum.loading;
  RequestStatusEnum newsTopHeadLineStatus = RequestStatusEnum.loading;

  String? errorMessage;

  String? selectedCategory;

  List<NewsArticleModel> newsTopHeadLineList = [];
  List<NewsArticleModel> newsEverythingList = [];

  final BaseNewsRepository newsRepository;

  getTopHeadLine({String? category}) async {
    try {
      newsTopHeadLineStatus = RequestStatusEnum.loading;
      notifyListeners();

      newsTopHeadLineList = await newsRepository.getTopHeadLine(selectedCategory: selectedCategory);

      newsTopHeadLineStatus = RequestStatusEnum.loaded;
      errorMessage = null;
    } catch (e) {
      newsTopHeadLineStatus = RequestStatusEnum.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  getEverything() async {
    try {
      newsEverythingList = await newsRepository.getEverything();

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
