import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/features/bookmark/bookmark_controller.dart';
import 'package:news_app/features/details/news_details_screen.dart';
import 'package:news_app/features/home/components/news_item.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookmarkController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Bookmarks"),
          centerTitle: true,
          actions: [
            Consumer<BookmarkController>(
              builder: (context, controller, child) {
                if (controller.bookmarks.isEmpty) return const SizedBox();

                return IconButton(
                  icon: Icon(
                    controller.isSearching ? Icons.close : Icons.search,
                  ),
                  onPressed: () {
                    if (controller.isSearching) {
                      controller.clearSearch();
                    } else {
                      _showSearchDialog(context);
                    }
                  },
                );
              },
            ),
            Consumer<BookmarkController>(
              builder: (context, controller, child) {
                if (controller.bookmarks.isEmpty) return const SizedBox();

                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'clear') {
                      _showClearConfirmation(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'clear',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Clear All'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Consumer<BookmarkController>(
          builder: (context, controller, child) {
            switch (controller.bookmarksStatus) {
              case RequestStatusEnum.loading:
                return const Center(child: CircularProgressIndicator());

              case RequestStatusEnum.error:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: AppSizes.ph16),
                      Text(
                        controller.errorMessage ?? 'An error occurred',
                        style: TextStyle(fontSize: AppSizes.sp16),
                      ),
                      SizedBox(height: AppSizes.ph16),
                      ElevatedButton(
                        onPressed: () => controller.loadBookmarks(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );

              case RequestStatusEnum.loaded:
                if (controller.bookmarks.isEmpty) {
                  return _buildEmptyState(controller);
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refresh(),
                  child: Column(
                    children: [
                      if (controller.isSearching)
                        Padding(
                          padding: EdgeInsets.all(AppSizes.pw16),
                          child: Text(
                            '${controller.bookmarks.length} result(s) for "${controller.searchQuery}"',
                            style: TextStyle(
                              fontSize: AppSizes.sp14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: AppSizes.ph16),
                          itemCount: controller.bookmarks.length,
                          itemBuilder: (context, index) {
                            final bookmark = controller.bookmarks[index];
                            final article = controller.getArticleFromBookmark(bookmark);

                            return Dismissible(
                              key: Key(bookmark.url),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: AppSizes.pw20),
                                color: Colors.red,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await _showDeleteConfirmation(context);
                              },
                              onDismissed: (direction) {
                                controller.removeBookmark(bookmark.url);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Bookmark removed'),
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {
                                        controller.addBookmark(article);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: NewsItem(model: article),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BookmarkController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            controller.isSearching ? Icons.search_off : Icons.bookmark_border,
            size: 100,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: AppSizes.ph24),
          Text(
            controller.isSearching
                ? 'No bookmarks found'
                : 'No bookmarks yet',
            style: TextStyle(
              fontSize: AppSizes.sp20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: AppSizes.ph8),
          Text(
            controller.isSearching
                ? 'Try a different search term'
                : 'Start bookmarking articles to see them here',
            style: TextStyle(
              fontSize: AppSizes.sp14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          if (controller.isSearching) ...[
            SizedBox(height: AppSizes.ph16),
            TextButton(
              onPressed: () => controller.clearSearch(),
              child: const Text('Clear Search'),
            ),
          ],
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final controller = context.read<BookmarkController>();
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Bookmarks'),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter search term...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchBookmarks(value);
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchBookmarks(searchController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Bookmark'),
        content: const Text('Are you sure you want to remove this bookmark?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    final controller = context.read<BookmarkController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks'),
        content: Text(
          'Are you sure you want to remove all ${controller.bookmarkCount} bookmarks? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearAllBookmarks();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All bookmarks cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}