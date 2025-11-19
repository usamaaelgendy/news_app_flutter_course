import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/core/extensions/date_time_extension.dart';
import 'package:news_app/core/theme/light_color.dart';
import 'package:news_app/core/widgets/bookmark_button.dart';
import 'package:news_app/core/widgets/custom_cached_network_image.dart';
import 'package:news_app/features/details/news_details_screen.dart';
import 'package:news_app/features/home/components/trending_news_shimmer.dart';
import 'package:news_app/features/home/components/view_all_component.dart';
import 'package:news_app/features/home/home_controller.dart';
import 'package:provider/provider.dart';

class TrendingNews extends StatelessWidget {
  const TrendingNews({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSizes.h330,
        child: Stack(
          children: [
            SizedBox(
              height: AppSizes.h240,
              width: double.infinity,
              child: Image.asset("assets/images/background.png", fit: BoxFit.cover),
            ),

            Positioned.fill(
              top: AppSizes.ph70,
              child: Column(
                children: [
                  Text(
                    "NEWST",
                    style: TextStyle(
                      fontSize: AppSizes.sp40,
                      fontWeight: FontWeight.w600,
                      color: LightColors.primaryColor,
                    ),
                  ),

                  SizedBox(height: AppSizes.ph6),

                  ViewAllComponent(title: 'Trending News', onTap: () {}),

                  SizedBox(height: AppSizes.ph12),

                  SizedBox(
                    height: AppSizes.h140,
                    child: Consumer<HomeController>(
                      builder: (BuildContext context, HomeController controller, Widget? child) {
                        switch (controller.everythingStatus) {
                          case RequestStatusEnum.loading:
                            return TrendingNewsShimmer();
                          case RequestStatusEnum.error:
                            return Center(child: Text(controller.errorMessage!));
                          case RequestStatusEnum.loaded:
                            return ListView.separated(
                              padding: EdgeInsets.only(left: AppSizes.pw16),
                              itemCount: controller.newsEverythingList.take(6).length,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (BuildContext context, int index) => SizedBox(width: AppSizes.pw12),
                              itemBuilder: (BuildContext context, int index) {
                                final model = controller.newsEverythingList[index];
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) { 
                                      return NewsDetailsScreen(model: model,);
                                    }));
                                  },
                                  child: SizedBox(
                                    width: 240,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(AppSizes.r12),
                                      child: Stack(
                                        children: [
                                          if (model.urlToImage != null)
                                            CustomCachedNetworkImage(
                                              imagePath: model.urlToImage ?? "",
                                              width: AppSizes.w240,
                                              height: AppSizes.h140,
                                            ),
                                  
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.black.withValues(alpha: 0.5),
                                                    Colors.black.withValues(alpha: 0.7),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            top: AppSizes.ph8,
                                            right: AppSizes.pw8,
                                            child: BookmarkButton(
                                              article: model,
                                              size: 24,
                                            ),
                                          ),

                                          Positioned(
                                            bottom: AppSizes.ph12,
                                            right: AppSizes.pw12,
                                            left: AppSizes.pw12,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  model.title,
                                                  style: TextStyle(
                                                    color: Color(0xFFFFFCFC),
                                                    fontSize: AppSizes.sp14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                                SizedBox(height: AppSizes.ph6),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage: NetworkImage(model.urlToImage.toString()),
                                                            radius: AppSizes.r10,
                                                          ),
                                                          SizedBox(width: AppSizes.pw6),
                                                          Expanded(
                                                            child: Text(
                                                              model.author ?? "",
                                                              style: TextStyle(
                                                                color: Color(0xFFFFFCFC),
                                                                fontSize: AppSizes.sp12,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      model.publishedAt.formatDateTime(),
                                                      style: TextStyle(
                                                        color: Color(0xFFFFFCFC),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: AppSizes.sp14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
