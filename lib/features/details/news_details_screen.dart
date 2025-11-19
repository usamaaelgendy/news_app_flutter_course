import 'dart:math';

import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/extensions/date_time_extension.dart';
import 'package:news_app/core/widgets/bookmark_button.dart';
import 'package:news_app/core/widgets/custom_cached_network_image.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key, required this.model});

  final NewsArticleModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("News Details"), centerTitle: true),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.pw16),
          child: Column(
            children: [
              SizedBox(height: AppSizes.ph8),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.r4),
                child: CustomCachedNetworkImage(
                  imagePath: model.urlToImage ?? "",
                  height: AppSizes.h200,
                  width: double.infinity,
                ),
              ),

              SizedBox(height: AppSizes.ph16),

              Text(
                model.title ?? "",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: AppSizes.ph16),

              Row(
                children: [
                  if (model.urlToImage != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(model.urlToImage!),
                      radius: AppSizes.r16,
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
                            fontSize: AppSizes.sp14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: AppSizes.pw8),
                        Expanded(
                          child: Text(
                            model.publishedAt.formatDateTime(),
                            style: TextStyle(
                              color: Color(0xFF141414),
                              fontSize: AppSizes.sp14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        BookmarkButton(
                          article: model,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.ph16),

              Text(
                model.description ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
