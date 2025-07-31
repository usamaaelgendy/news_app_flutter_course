import 'package:flutter/material.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/features/auth/login_screen.dart';
import 'package:news_app/features/onboarding/controller/onboarding_controller.dart';
import 'package:news_app/features/onboarding/models/onboarding_model.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create: (BuildContext context) => OnboardingController(),
      builder: (context, child) {
        final controller = context.read<OnboardingController>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFf5f5f5),
            actions: [
              Consumer<OnboardingController>(
                builder: (
                  BuildContext context,
                  OnboardingController value,
                  Widget? child,
                ) {
                  return value.isLastPage
                      ? SizedBox()
                      : TextButton(
                        onPressed: () {
                          _onFinish(context);
                        },
                        child: Text('Skip', style: TextStyle(fontSize: 16)),
                      );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: (int index) {
                      context.read<OnboardingController>().onPageChange(index);
                    },
                    itemCount: OnboardingModel.onboardingList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final OnboardingModel model =
                          OnboardingModel.onboardingList[index];
                      return Column(
                        children: [
                          Image.asset(model.image),
                          SizedBox(height: 24),
                          Text(
                            model.title,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF4E4B66),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            model.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6E7191),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                        ],
                      );
                    },
                  ),
                ),

                Consumer<OnboardingController>(
                  builder: (
                    BuildContext context,
                    OnboardingController value,
                    Widget? child,
                  ) {
                    return SmoothPageIndicator(
                      controller: value.pageController,
                      count: 3,
                      effect: SwapEffect(activeDotColor: Color(0xFFC53030)),
                    );
                  },
                ),
                SizedBox(height: 112),
                Consumer<OnboardingController>(
                  builder: (
                    BuildContext context,
                    OnboardingController value,
                    Widget? child,
                  ) {
                    return ElevatedButton(
                      onPressed: () {
                        if (!value.isLastPage) {
                          controller.pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _onFinish(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 52),
                      ),
                      child: Text(value.isLastPage ? 'Get Started' : 'Next'),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
