import 'package:flutter/material.dart';
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
            body: Column(
              children: [
                TrendingNews(),
                ViewAllComponent(title: 'Categories', titleColor: Color(0xFF141414), onTap: () {}),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                  child: SizedBox(
                    height: 30,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(
                          categories[index],
                          style: TextStyle(color: Color(0xFF363636), fontSize: 16, fontWeight: FontWeight.w400),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(width: 12);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

final List<String> categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"];
