import 'package:hive_ce_flutter/adapters.dart';

part 'bookmark_model.g.dart';

@HiveType(typeId: 1)
class BookmarkModel {
  @HiveField(0)
  String? author;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String url;

  @HiveField(4)
  String? urlToImage;

  @HiveField(5)
  DateTime publishedAt;

  @HiveField(6)
  String? content;

  @HiveField(7)
  DateTime bookmarkedAt;

  BookmarkModel({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.bookmarkedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
      'bookmarkedAt': bookmarkedAt.toIso8601String(),
    };
  }

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      author: map['author'] as String?,
      title: map['title'] as String,
      description: map['description'] as String?,
      url: map['url'] as String,
      urlToImage: map['urlToImage'] as String?,
      publishedAt: DateTime.parse(map['publishedAt'] as String),
      content: map['content'] as String?,
      bookmarkedAt: DateTime.parse(map['bookmarkedAt'] as String),
    );
  }

  BookmarkModel copyWith({
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
    DateTime? bookmarkedAt,
  }) {
    return BookmarkModel(
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      bookmarkedAt: bookmarkedAt ?? this.bookmarkedAt,
    );
  }
}