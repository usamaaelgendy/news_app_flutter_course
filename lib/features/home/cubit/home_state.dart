part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.everythingStatus = RequestStatusEnum.loading,
    this.newsTopHeadLineStatus = RequestStatusEnum.loading,
    this.errorMessage,
    this.selectedCategory,
    this.newsTopHeadLineList = const [],
    this.newsEverythingList = const [],
  });

  final RequestStatusEnum everythingStatus;
  final RequestStatusEnum newsTopHeadLineStatus;

  final String? errorMessage;

  final String? selectedCategory;

  final List<NewsArticleModel> newsTopHeadLineList;
  final List<NewsArticleModel> newsEverythingList;

  HomeState copyWith({
    RequestStatusEnum? everythingStatus,
    RequestStatusEnum? newsTopHeadLineStatus,
    String? errorMessage,
    String? selectedCategory,
    List<NewsArticleModel>? newsTopHeadLineList,
    List<NewsArticleModel>? newsEverythingList,
  }) {
    return HomeState(
      everythingStatus: everythingStatus ?? this.everythingStatus,
      newsTopHeadLineStatus: newsTopHeadLineStatus ?? this.newsTopHeadLineStatus,
      errorMessage: errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      newsTopHeadLineList: newsTopHeadLineList ?? this.newsTopHeadLineList,
      newsEverythingList: newsEverythingList ?? this.newsEverythingList,
    );
  }

  @override
  List<Object?> get props => [
    everythingStatus,
    newsTopHeadLineStatus,
    errorMessage,
    selectedCategory,
    newsTopHeadLineList,
    newsEverythingList,
  ];
}
