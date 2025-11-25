import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/core/repos/news_repository.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.newsRepository) : super(const HomeState()) {
    getTopHeadLine();
    getEverything();
  }

  final BaseNewsRepository newsRepository;

  getTopHeadLine({String? category}) async {
    try {
      emit(state.copyWith(newsTopHeadLineStatus: RequestStatusEnum.loading));

      final articles = await newsRepository.getTopHeadLine(
        selectedCategory: state.selectedCategory,
      );

      emit(
        state.copyWith(
          newsTopHeadLineList: articles,
          newsTopHeadLineStatus: RequestStatusEnum.loaded,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          newsTopHeadLineStatus: RequestStatusEnum.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  getEverything() async {
    try {
      final articles = await newsRepository.getEverything();

      emit(
        state.copyWith(
          newsEverythingList: articles,
          everythingStatus: RequestStatusEnum.loaded,
          errorMessage: null,
        ),
      );

    } catch (e) {

      emit(state.copyWith(
        errorMessage: e.toString(),
        everythingStatus: RequestStatusEnum.error,
      ));
    }
  }

  void updateSelectedCategory(String category) {
    emit(state.copyWith(selectedCategory: category));

    getTopHeadLine(category: state.selectedCategory );
  }
}
