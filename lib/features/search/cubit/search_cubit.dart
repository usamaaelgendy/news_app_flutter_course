import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/core/repos/news_repository.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.newsRepository) : super(const SearchState());

  TextEditingController searchController = TextEditingController();

  final BaseNewsRepository newsRepository;

  getEverything() async {
    try {
      emit(
        state.copyWith(
          newsEverythingList: await newsRepository.getEverything(
            query: searchController.text,
          ),
          everythingStatus: RequestStatusEnum.loaded,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          everythingStatus: RequestStatusEnum.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
