import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.h24, horizontal: AppSizes.w16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/person.png"),
                    radius: AppSizes.r60,
                    backgroundColor: Colors.transparent,
                  ),
                  GestureDetector(
                    onTap: () {
                      showImageSourceDialog(context);
                    },
                    child: Container(
                      height: AppSizes.w45,
                      width: AppSizes.h45,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Select Image Source", style: TextStyle(fontSize: AppSizes.sp16)),

          children: [
            SimpleDialogOption(
              onPressed: () {},
              padding: EdgeInsets.all(AppSizes.pw16),
              child: Row(children: [Icon(Icons.camera_alt), SizedBox(width: AppSizes.pw8), Text("Camera")]),
            ),
            SimpleDialogOption(
              onPressed: () {

              },
              padding: EdgeInsets.all(AppSizes.pw16),
              child: Row(children: [Icon(Icons.photo_library), SizedBox(width: AppSizes.pw8), Text("Galley")]),
            ),
          ],
        );
      },
    );
  }
}
