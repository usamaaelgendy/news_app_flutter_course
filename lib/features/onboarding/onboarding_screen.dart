import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/features/auth/login_screen.dart';
import 'package:news_app/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:news_app/features/onboarding/models/onboarding_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  _onFinish(BuildContext context) async {
    await PreferencesManager().setBool("onboarding_complete", true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OnboardingCubit(),
      child: Builder(
        builder: (BuildContext context) {
          final controller = context.read<OnboardingCubit>();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFf5f5f5),
              actions: [
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (BuildContext context, state) {
                    return state.isLastPage
                        ? const SizedBox()
                        : TextButton(
                          onPressed: () {
                            _onFinish(context);
                          },
                          child: Text('Skip', style: TextStyle(fontSize: AppSizes.sp16)),
                        );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.ph30,
                horizontal: AppSizes.pw16,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: (int index) {
                        context.read<OnboardingCubit>().onPageChange(index);
                      },
                      itemCount: OnboardingModel.onboardingList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final OnboardingModel model =
                            OnboardingModel.onboardingList[index];
                        return Column(
                          children: [
                            Image.asset(model.image),
                            SizedBox(height: AppSizes.ph24),
                            Text(
                              model.title,
                              style: TextStyle(
                                fontSize: AppSizes.sp20,
                                color: const Color(0xFF4E4B66),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: AppSizes.ph12),
                            Text(
                              model.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppSizes.sp16,
                                color: const Color(0xFF6E7191),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                          ],
                        );
                      },
                    ),
                  ),

                  BlocBuilder<OnboardingCubit, OnboardingState>(
                    builder: (BuildContext context, state) {
                      return SmoothPageIndicator(
                        controller: context.read<OnboardingCubit>().pageController,
                        count: 3,
                        effect: const SwapEffect(activeDotColor: Color(0xFFC53030)),
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.ph112),
                  BlocBuilder<OnboardingCubit, OnboardingState>(
                    builder: (BuildContext context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (!state.isLastPage) {
                            controller.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _onFinish(context);
                          }
                        },
                        child: Text(state.isLastPage ? 'Get Started' : 'Next'),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
