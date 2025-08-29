import 'dart:math';

import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/date_time_extension.dart';
import 'package:news_app/core/widgets/custom_cached_network_image.dart';
import 'package:news_app/core/widgets/custom_svg_picture.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key, required this.model});

  final NewsArticleModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomCachedNetworkImage(imagePath: model.urlToImage ?? ""),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                ),
                Row(
                  children: [
                    if (model.urlToImage != null)
                      CircleAvatar(backgroundImage: NetworkImage(model.urlToImage!), radius: 10),
                    SizedBox(width: 6),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            (model.author ?? "").substring(0, min((model.author ?? "").length, 10)),
                            style: TextStyle(color: Color(0xFF141414), fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              model.publishedAt.formatDateTime(),
                              style: TextStyle(color: Color(0xFF141414), fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                          CustomSvgPicture.withoutColor(path: 'assets/images/bookmark.svg'),
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
    );
  }
}
