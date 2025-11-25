part of 'search_cubit.dart';

class SearchState extends Equatable {
  final List<NewsArticleModel> newsEverythingList;

  final RequestStatusEnum everythingStatus;

  final String? errorMessage;

  const SearchState({
    this.newsEverythingList = const [],
    this.everythingStatus = RequestStatusEnum.loading,
    this.errorMessage,
  });

  SearchState copyWith({
    List<NewsArticleModel>? newsEverythingList,
    RequestStatusEnum? everythingStatus,
    String? errorMessage,
  }) {
    return SearchState(
      newsEverythingList: newsEverythingList ?? this.newsEverythingList,
      everythingStatus: everythingStatus ?? this.everythingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [newsEverythingList, everythingStatus, errorMessage];
}
