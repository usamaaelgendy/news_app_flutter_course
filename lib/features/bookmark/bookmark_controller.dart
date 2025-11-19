import 'package:flutter/material.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/core/mixins/safe_notify_mixin.dart';
import 'package:news_app/features/bookmark/data/bookmark_repository.dart';
import 'package:news_app/features/bookmark/models/bookmark_model.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class BookmarkController extends ChangeNotifier with SafeNotify {
  final BookmarkRepository _repository = BookmarkRepository();

  // State variables
  RequestStatusEnum bookmarksStatus = RequestStatusEnum.loading;
  List<BookmarkModel> bookmarks = [];
  String? errorMessage;

  // Search state
  String searchQuery = '';

  BookmarkController() {
    loadBookmarks();
  }

  /// Load all bookmarks from repository
  void loadBookmarks() {
    try {
      bookmarksStatus = RequestStatusEnum.loading;
      safeNotify();

      if (searchQuery.isEmpty) {
        bookmarks = _repository.getBookmarks();
      } else {
        bookmarks = _repository.searchBookmarks(searchQuery);
      }

      bookmarksStatus = RequestStatusEnum.loaded;
      errorMessage = null;
    } catch (e) {
      bookmarksStatus = RequestStatusEnum.error;
      errorMessage = e.toString();
    }
    safeNotify();
  }

  /// Toggle bookmark status for an article
  /// Returns true if article was added to bookmarks, false if removed
  Future<bool> toggleBookmark(NewsArticleModel article) async {
    try {
      final wasAdded = await _repository.toggleBookmark(article);

      // Reload bookmarks to update UI
      loadBookmarks();

      return wasAdded;
    } catch (e) {
      errorMessage = e.toString();
      safeNotify();
      return false;
    }
  }

  /// Add a bookmark
  Future<void> addBookmark(NewsArticleModel article) async {
    try {
      await _repository.addBookmark(article);
      loadBookmarks();
    } catch (e) {
      errorMessage = e.toString();
      safeNotify();
    }
  }

  /// Remove a bookmark by URL
  Future<void> removeBookmark(String articleUrl) async {
    try {
      await _repository.removeBookmark(articleUrl);
      loadBookmarks();
    } catch (e) {
      errorMessage = e.toString();
      safeNotify();
    }
  }

  /// Check if an article is bookmarked
  bool isArticleBookmarked(String? articleUrl) {
    return _repository.isBookmarked(articleUrl);
  }

  /// Get total bookmark count
  int get bookmarkCount => _repository.getBookmarkCount();

  /// Clear all bookmarks with confirmation
  Future<void> clearAllBookmarks() async {
    try {
      await _repository.clearAllBookmarks();
      loadBookmarks();
    } catch (e) {
      errorMessage = e.toString();
      safeNotify();
    }
  }

  /// Search bookmarks
  void searchBookmarks(String query) {
    searchQuery = query;
    loadBookmarks();
  }


  /// Convert bookmark to article for navigation
  NewsArticleModel getArticleFromBookmark(BookmarkModel bookmark) {
    return _repository.bookmarkToArticle(bookmark);
  }

  /// Refresh bookmarks (for pull-to-refresh)
  Future<void> refresh() async {
    loadBookmarks();
  }

  /// Get bookmarks as articles for easier UI rendering
  List<NewsArticleModel> get bookmarksAsArticles {
    return bookmarks.map((bookmark) => _repository.bookmarkToArticle(bookmark)).toList();
  }
}