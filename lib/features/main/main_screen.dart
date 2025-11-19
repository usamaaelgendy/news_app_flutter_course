import 'package:flutter/material.dart';
import 'package:news_app/features/bookmark/bookmark_screen.dart';
import 'package:news_app/features/bookmark/data/bookmark_repository.dart';
import 'package:news_app/features/home/home_screen.dart';
import 'package:news_app/features/profile/profile_screen.dart';
import 'package:news_app/features/search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _bookmarkCount = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    BookmarkScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _updateBookmarkCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update bookmark count when screen becomes visible
    _updateBookmarkCount();
  }

  void _updateBookmarkCount() {
    setState(() {
      _bookmarkCount = BookmarkRepository().getBookmarkCount();
    });
  }

  Widget _buildBookmarkIcon() {
    if (_bookmarkCount == 0) {
      return const Icon(Icons.bookmark_border);
    }

    return Badge(
      label: Text(_bookmarkCount.toString()),
      child: const Icon(Icons.bookmark_border),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          // Update bookmark count when navigating away from bookmark screen
          if (_currentIndex == 2) {
            _updateBookmarkCount();
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: _buildBookmarkIcon(),
            label: "Bookmark",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
      body: _screens[_currentIndex],
    );
  }
}
