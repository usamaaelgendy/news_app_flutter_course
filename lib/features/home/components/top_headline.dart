import 'dart:math';

import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/date_time_extension.dart';
import 'package:news_app/features/home/home_controller.dart';
import 'package:provider/provider.dart';

class TopHeadline extends StatelessWidget {
  const TopHeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, controller, Widget? child) {
        return SliverList.builder(
          itemCount: controller.newsTopHeadLineList.length,
          itemBuilder: (BuildContext context, int index) {
            final model = controller.newsTopHeadLineList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  model.urlToImage != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(model.urlToImage ?? "", height: 80, width: 140, fit: BoxFit.cover),
                      )
                      : SizedBox(height: 80, width: 140),
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
                                    style: TextStyle(
                                      color: Color(0xFF141414),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    model.publishedAt.formatDateTime(),
                                    style: TextStyle(
                                      color: Color(0xFF141414),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
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
            );
          },
        );
      },
    );
  }
}
