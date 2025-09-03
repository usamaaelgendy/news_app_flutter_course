import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/theme/light_color.dart';
import 'package:news_app/features/home/categories_screen.dart';
import 'package:news_app/features/home/components/view_all_component.dart';
import 'package:news_app/features/home/home_controller.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<HomeController>(
        builder: (BuildContext context, controller, Widget? child) {
          return Column(
            children: [
              ViewAllComponent(
                title: 'Categories',
                titleColor: Color(0xFF141414),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext _) {
                        return ChangeNotifierProvider.value(
                          value: Provider.of<HomeController>(context, listen: false),
                          child: CategoriesScreen(),
                        );
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: AppSizes.pw16, top: AppSizes.ph16, bottom: AppSizes.ph16),
                child: SizedBox(
                  height: AppSizes.h35,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    padding: EdgeInsets.only(right: AppSizes.pw16),
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected = categories[index] == controller.selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          controller.updateSelectedCategory(categories[index]);
                        },
                        child: IntrinsicWidth(
                          child: Column(
                            children: [
                              Text(
                                categories[index][0].toUpperCase() + categories[index].substring(1),
                                style: TextStyle(
                                  color: Color(0xFF363636),
                                  fontSize: AppSizes.sp16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              if (isSelected) ...[
                                SizedBox(height: AppSizes.ph4),
                                Container(height: AppSizes.h2, color: LightColors.primaryColor),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: AppSizes.pw12);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

final List<String> categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"];
