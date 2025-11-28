import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/features/bookmark/cubit/bookmark_cubit.dart';
import 'package:news_app/features/bookmark/widgets/empty_state.dart';
import 'package:news_app/features/home/components/news_item.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarkCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Bookmarks"),
          centerTitle: true,
          actions: [
            BlocBuilder<BookmarkCubit, BookmarkState>(
              builder: (context, state) {
                if (state.bookmarks.isEmpty) return const SizedBox();

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
        body: BlocBuilder<BookmarkCubit, BookmarkState>(
          builder: (context, state) {
            switch (state.bookmarksStatus) {
              case RequestStatusEnum.initial:
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
                        state.errorMessage ?? 'An error occurred',
                        style: TextStyle(fontSize: AppSizes.sp16),
                      ),
                      SizedBox(height: AppSizes.ph16),
                      ElevatedButton(
                        onPressed: () => context.read<BookmarkCubit>().loadBookmarks(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );

              case RequestStatusEnum.loaded:
                if (state.bookmarks.isEmpty) {
                  return const EmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<BookmarkCubit>().refresh(),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: AppSizes.ph16),
                          itemCount: state.bookmarks.length,
                          itemBuilder: (context, index) {
                            final bookmark = state.bookmarks[index];
                            final article = context
                                .read<BookmarkCubit>()
                                .getArticleFromBookmark(bookmark);

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
                                context.read<BookmarkCubit>().removeBookmark(
                                  bookmark.url,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Bookmark removed'),
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {
                                        context.read<BookmarkCubit>().addBookmark(
                                          article,
                                        );
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
    final controller = context.read<BookmarkCubit>();

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
