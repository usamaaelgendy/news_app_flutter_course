import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/features/home/components/news_item.dart';
import 'package:news_app/features/home/components/top_headline_shimmer.dart';
import 'package:news_app/features/home/cubit/home_cubit.dart';

class TopHeadline extends StatelessWidget {
  const TopHeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, state) {
        switch (state.newsTopHeadLineStatus) {
          case RequestStatusEnum.loading:
            return TopHeadlineShimmer();
          case RequestStatusEnum.error:
            return SliverToBoxAdapter(child: Center(child: Text(state.errorMessage!)));
          case RequestStatusEnum.loaded:
            return SliverList.builder(
              itemCount: state.newsTopHeadLineList.length,
              itemBuilder: (BuildContext context, int index) {
                final model = state.newsTopHeadLineList[index];
                return NewsItem(model: model);
              },
            );
        }
      },
    );
  }
}
