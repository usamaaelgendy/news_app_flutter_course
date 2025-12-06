import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/datasource/remote_data/api_service.dart';
import 'package:news_app/core/datasource/remote_data/news/news_api_service.dart';
import 'package:news_app/core/repos/news_repository.dart';
import 'package:news_app/features/home/components/categories_list.dart';
import 'package:news_app/features/home/components/top_headline.dart';
import 'package:news_app/features/home/components/trending_news.dart';
import 'package:news_app/features/home/cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return HomeCubit(NewsRepository(NewsApiService()));
      },
      child: const Scaffold(
        body: CustomScrollView(
          slivers: [TrendingNews(), CategoriesList(), TopHeadline()],
        ),
      ),
    );
  }
}
