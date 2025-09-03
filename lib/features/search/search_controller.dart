import 'package:flutter/cupertino.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/core/mixins/safe_notify_mixin.dart';
import 'package:news_app/core/repos/news_repository.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class SearchScreenController extends ChangeNotifier with SafeNotify {
  SearchScreenController(this.newsRepository);

  TextEditingController searchController = TextEditingController();

  final BaseNewsRepository newsRepository;

  List<NewsArticleModel> newsEverythingList = [];
  RequestStatusEnum everythingStatus = RequestStatusEnum.loading;
  String? errorMessage;

  getEverything() async {
    try {
      newsEverythingList = await newsRepository.getEverything(query: searchController.text);

      everythingStatus = RequestStatusEnum.loaded;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      everythingStatus = RequestStatusEnum.error;
    }

    safeNotify();
  }
}
