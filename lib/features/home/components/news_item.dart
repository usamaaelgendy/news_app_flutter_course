import 'dart:math';

import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/extensions/date_time_extension.dart';
import 'package:news_app/core/widgets/bookmark_button.dart';
import 'package:news_app/core/widgets/custom_cached_network_image.dart';
import 'package:news_app/features/details/news_details_screen.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key, required this.model});

  final NewsArticleModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return NewsDetailsScreen(model: model);
            },
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.pw16, vertical: AppSizes.ph8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.r8),
              child: CustomCachedNetworkImage(imagePath: model.urlToImage ?? ""),
            ),
            SizedBox(width: AppSizes.pw8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: TextStyle(
                      fontSize: AppSizes.sp16,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      if (model.urlToImage != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(model.urlToImage!),
                          radius: AppSizes.r10,
                        ),
                      SizedBox(width: AppSizes.pw6),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              (model.author ?? "").substring(
                                0,
                                min((model.author ?? "").length, 10),
                              ),
                              style: TextStyle(
                                color: Color(0xFF141414),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: AppSizes.pw8),
                            Expanded(
                              child: Text(
                                model.publishedAt.formatDateTime(),
                                style: TextStyle(
                                  color: Color(0xFF141414),
                                  fontSize: AppSizes.sp12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            BookmarkButton(
                              article: model,
                              size: 20,
                            ),
                          ],
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
  }
}
