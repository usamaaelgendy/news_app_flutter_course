import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TrendingNewsShimmer extends StatelessWidget {
  const TrendingNewsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(left: 16),
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (BuildContext context, int index) => SizedBox(width: 12),
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(height: 140, width: 240, color: Colors.white),
        );
      },
    );
  }
}
