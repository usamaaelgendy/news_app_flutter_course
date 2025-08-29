import 'package:flutter/material.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/core/extensions/date_time_extension.dart';
import 'package:news_app/core/theme/light_color.dart';
import 'package:news_app/core/widgets/custom_cached_network_image.dart';
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

                  ViewAllComponent(title: 'Trending News', onTap: () {}),

                  SizedBox(height: 12),

                  SizedBox(
                    height: 140,
                    child: Consumer<HomeController>(
                      builder: (BuildContext context, HomeController controller, Widget? child) {
                        switch (controller.everythingStatus) {
                          case RequestStatusEnum.loading:
                            return TrendingNewsShimmer();
                          case RequestStatusEnum.error:
                            return Center(child: Text(controller.errorMessage!));
                          case RequestStatusEnum.loaded:
                            return ListView.separated(
                              padding: EdgeInsets.only(left: 16),
                              itemCount: controller.newsEverythingList.take(6).length,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 12),
                              itemBuilder: (BuildContext context, int index) {
                                final model = controller.newsEverythingList[index];
                                return SizedBox(
                                  width: 240,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      children: [
                                        if (model.urlToImage != null)
                                          CustomCachedNetworkImage(
                                            imagePath: model.urlToImage ?? "",
                                            width: 240,
                                            height: 140,
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
                                          bottom: 12,
                                          right: 12,
                                          left: 12,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                model.title,
                                                style: TextStyle(
                                                  color: Color(0xFFFFFCFC),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage: NetworkImage(model.urlToImage.toString()),
                                                          radius: 10,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Expanded(
                                                          child: Text(
                                                            model.author ?? "",
                                                            style: TextStyle(
                                                              color: Color(0xFFFFFCFC),
                                                              fontSize: 12,
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
                                                      fontSize: 14,
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
