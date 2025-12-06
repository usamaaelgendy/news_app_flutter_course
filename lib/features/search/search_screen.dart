import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/datasource/remote_data/auth/auth_api_service.dart';
import 'package:news_app/core/datasource/remote_data/news/news_api_service.dart';
import 'package:news_app/core/repos/news_repository.dart';
import 'package:news_app/features/details/news_details_screen.dart';
import 'package:news_app/features/search/cubit/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SearchCubit(NewsRepository(NewsApiService()));
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Search"), centerTitle: true),
        body: Padding(
          padding: EdgeInsets.all(AppSizes.pw16),
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (BuildContext context, state) {
              final controller = context.read<SearchCubit>();
              return Column(
                children: [
                  TextField(
                    controller: controller.searchController,
                    onChanged: (value) {
                      controller.getEverything();
                    },
                    decoration: InputDecoration(
                      hintText: "Search",
                      suffixIcon: Icon(
                        Icons.search,
                        size: AppSizes.r30,
                        color: Color(0xFFA0A0A0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.newsEverythingList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        final model = state.newsEverythingList[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSizes.pw8),
                          child: ListTile(
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
                            leading: Icon(
                              Icons.search,
                              size: AppSizes.r20,
                              color: const Color(0xFFA0A0A0),
                            ),
                            title: Text(model.title, maxLines: 1),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(color: Color(0xFFA0A0A0));
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
