import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  final PageController pageController = PageController();

  void onPageChange(int index) {
    if (index == 2) {
      emit(state.copyWith(isLastPage: true, currentIndex: index));
    } else {
      emit(state.copyWith(currentIndex: index, isLastPage: false));
    }
  }
}
