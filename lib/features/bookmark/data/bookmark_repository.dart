import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/constants.dart';
import 'package:news_app/features/bookmark/models/bookmark_model.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class BookmarkRepository {
  BookmarkRepository._internal();

  static final BookmarkRepository _instance = BookmarkRepository._internal();

  factory BookmarkRepository() => _instance;

  Box<BookmarkModel>? _bookmarkBox;

  Box<BookmarkModel> get bookmarkBox {
    if (_bookmarkBox == null) {
      throw Exception("BookmarkRepository not initialized");
    }
    return _bookmarkBox!;
  }

  Future<void> init() async {
    Hive.registerAdapter(BookmarkModelAdapter());
    _bookmarkBox = await Hive.openBox<BookmarkModel>(Constants.bookmarkBox);
  }

  /// Add a news article to bookmarks
  /// Uses article URL as unique key to prevent duplicates
  Future<void> addBookmark(NewsArticleModel article) async {
    final bookmark = BookmarkModel(
      author: article.author,
      title: article.title,
      description: article.description,
      url: article.url ?? '',
      urlToImage: article.urlToImage,
      publishedAt: article.publishedAt,
      content: article.content,
      bookmarkedAt: DateTime.now(),
    );

    await bookmarkBox.put(article.url, bookmark);
  }

  /// Remove a bookmark by article URL
  Future<void> removeBookmark(String articleUrl) async {
    await bookmarkBox.delete(articleUrl);
  }

  /// Get all bookmarks, sorted by most recently bookmarked first
  List<BookmarkModel> getBookmarks() => bookmarkBox.values.toList();

  /// Check if an article is bookmarked
  bool isBookmarked(String? articleUrl) {
    if (articleUrl == null || articleUrl.isEmpty) return false;
    return bookmarkBox.containsKey(articleUrl);
  }

  /// Get a single bookmark by URL
  BookmarkModel? getBookmark(String articleUrl) {
    return bookmarkBox.get(articleUrl);
  }

  /// Toggle bookmark status (add if not exists, remove if exists)
  /// Returns true if bookmark was added, false if removed
  Future<bool> toggleBookmark(NewsArticleModel article) async {
    if (isBookmarked(article.url)) {
      await removeBookmark(article.url!);
      return false;
    } else {
      await addBookmark(article);
      return true;
    }
  }

  /// Get total count of bookmarks
  int getBookmarkCount() {
    return bookmarkBox.length;
  }

  /// Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    await bookmarkBox.clear();
  }

  /// Search bookmarks by title or description
  List<BookmarkModel> searchBookmarks(String query) {
    if (query.isEmpty) return getBookmarks();

    final lowercaseQuery = query.toLowerCase();

    return bookmarkBox.values.where((bookmark) {
        final titleMatch = bookmark.title.toLowerCase().contains(lowercaseQuery);
        final descriptionMatch =
            bookmark.description?.toLowerCase().contains(lowercaseQuery) ?? false;
        final authorMatch =
            bookmark.author?.toLowerCase().contains(lowercaseQuery) ?? false;

        return titleMatch || descriptionMatch || authorMatch;
      }).toList()
      ..sort((a, b) => b.bookmarkedAt.compareTo(a.bookmarkedAt));
  }

  /// Convert BookmarkModel to NewsArticleModel
  NewsArticleModel bookmarkToArticle(BookmarkModel bookmark) {
    return NewsArticleModel(
      author: bookmark.author,
      title: bookmark.title,
      description: bookmark.description,
      url: bookmark.url,
      urlToImage: bookmark.urlToImage,
      publishedAt: bookmark.publishedAt,
      content: bookmark.content,
    );
  }
}
