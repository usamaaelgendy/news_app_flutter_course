import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/features/bookmark/bookmark_controller.dart';
import 'package:news_app/features/bookmark/widgets/empty_state.dart';
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

                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'clear') {
                      _showClearConfirmation(context);
                    }
                  },
                  itemBuilder:
                      (context) => [
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
                  return const EmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refresh(),
                  child: Column(
                    children: [
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
                                child: const Icon(Icons.delete, color: Colors.white),
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

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Bookmark'),
            content: const Text('Are you sure you want to remove this bookmark?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
      builder:
          (context) => AlertDialog(
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Clear All'),
              ),
            ],
          ),
    );
  }
}
