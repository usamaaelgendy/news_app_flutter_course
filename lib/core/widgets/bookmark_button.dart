import 'package:flutter/material.dart';
import 'package:news_app/features/bookmark/data/bookmark_repository.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class BookmarkButton extends StatefulWidget {
  final NewsArticleModel article;
  final double size;

  const BookmarkButton({
    super.key,
    required this.article,
    this.size = 24.0,
  });

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  final BookmarkRepository _repository = BookmarkRepository();
  bool _isBookmarked = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  void _checkBookmarkStatus() {
    setState(() {
      _isBookmarked = _repository.isBookmarked(widget.article.url);
    });
  }

  Future<void> _toggleBookmark() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    try {
      final wasAdded = await _repository.toggleBookmark(widget.article);

      setState(() {
        _isBookmarked = wasAdded;
        _isAnimating = false;
      });

      // Show feedback to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              wasAdded ? 'Article bookmarked' : 'Bookmark removed',
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isAnimating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleBookmark,
      child: AnimatedScale(
        scale: _isAnimating ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            key: ValueKey<bool>(_isBookmarked),
            size: widget.size,
            color: _isBookmarked ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
