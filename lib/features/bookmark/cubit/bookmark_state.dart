part of 'bookmark_cubit.dart';

class BookmarkState extends Equatable {
  const BookmarkState({
    this.bookmarksStatus = RequestStatusEnum.loading,
    this.bookmarks = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  final RequestStatusEnum bookmarksStatus;

  final List<BookmarkModel> bookmarks;

  final String? errorMessage;

  final String searchQuery;

  BookmarkState copyWith({
    RequestStatusEnum? bookmarksStatus,
    List<BookmarkModel>? bookmarks,
    String? errorMessage,
    String? searchQuery,
  }) {
    return BookmarkState(
      bookmarksStatus: bookmarksStatus ?? this.bookmarksStatus,
      bookmarks: bookmarks ?? this.bookmarks,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [bookmarksStatus, bookmarks, errorMessage, searchQuery];
}
