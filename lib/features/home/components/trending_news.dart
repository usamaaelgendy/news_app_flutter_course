import 'package:flutter/material.dart';
import 'package:news_app/core/theme/light_color.dart';
import 'package:news_app/features/home/home_controller.dart';
import 'package:provider/provider.dart';

class TrendingNews extends StatelessWidget {
  const TrendingNews({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Stack(
        children: [
          SizedBox(
            height: 240,
            width: double.infinity,
            child: Image.asset("assets/images/background.png", fit: BoxFit.cover),
          ),

          Positioned.fill(
            top: 70,
            child: Column(
              children: [
                Text(
                  "NEWST",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: LightColors.primaryColor),
                ),

                SizedBox(height: 6),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trending News",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "View all",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                SizedBox(
                  height: 140,
                  child: Consumer<HomeController>(
                    builder: (BuildContext context, HomeController controller, Widget? child) {
                      return (controller.errorMessage?.isNotEmpty ?? false)
                          ? Center(child: Text(controller.errorMessage!))
                          : controller.everythingLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.separated(
                        itemCount: controller.newsEverythingList.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) => SizedBox(width: 12),
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                if (controller.newsEverythingList[index].urlToImage != null)
                                  Image.network(controller.newsEverythingList[index].urlToImage!),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
