import 'package:flutter/material.dart';
import 'package:news_app/features/home/home_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeController(),
      child: Consumer<HomeController>(
        builder: (BuildContext context, controller, Widget? child) {
          return Scaffold(
            body:
                (controller.errorMessage?.isNotEmpty ?? false)
                    ? Center(child: Text(controller.errorMessage!))
                    : controller.everythingLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.newsTopHeadLineList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(
                                controller.newsTopHeadLineList[index].title,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
          );
        },
      ),
    );
  }
}
