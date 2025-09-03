import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:shimmer/shimmer.dart';

class TrendingNewsShimmer extends StatelessWidget {
  const TrendingNewsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(left: AppSizes.pw16),
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (BuildContext context, int index) => SizedBox(width: AppSizes.pw12),
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(height: AppSizes.h140, width: AppSizes.w240, color: Colors.white),
        );
      },
    );
  }
}
