import 'package:flutter/material.dart';
import 'package:news_app/core/theme/light_color.dart';

class CategoriesList extends StatefulWidget {
  CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
      child: SizedBox(
        height: 35,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: EdgeInsets.only(right: 16),
          itemBuilder: (BuildContext context, int index) {
            bool isSelected = categories[index] == selectedCategory;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = categories[index];
                });
              },
              child: IntrinsicWidth(
                child: Column(
                  children: [
                    Text(
                      categories[index][0].toUpperCase() + categories[index].substring(1),
                      style: TextStyle(color: Color(0xFF363636), fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    if (isSelected) ...[SizedBox(height: 4), Container(height: 2, color: LightColors.primaryColor)],
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(width: 12);
          },
        ),
      ),
    );
  }
}

final List<String> categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"];
