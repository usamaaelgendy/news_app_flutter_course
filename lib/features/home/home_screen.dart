import 'package:flutter/material.dart';
import 'package:news_app/features/home/components/categories_list.dart';
import 'package:news_app/features/home/components/trending_news.dart';
import 'package:news_app/features/home/components/view_all_component.dart';
import 'package:news_app/features/home/home_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeController(),
      child: Consumer<HomeController>(
        builder: (BuildContext context, controller, Widget? child) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TrendingNews(),
                  ViewAllComponent(title: 'Categories', titleColor: Color(0xFF141414), onTap: () {}),
                  CategoriesList(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.newsTopHeadLineList.length,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(height: 20, width: 50, color: Colors.red),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
