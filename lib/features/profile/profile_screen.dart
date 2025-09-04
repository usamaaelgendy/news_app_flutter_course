import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/features/profile/profile_controller.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileController>(
      create: (BuildContext context) => ProfileController(),
      child: Scaffold(
        appBar: AppBar(title: Text("Profile"), centerTitle: true),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.h24, horizontal: AppSizes.w16),
            child: Consumer<ProfileController>(
              builder: (BuildContext context, ProfileController controller, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              controller.selectedImage == null
                                  ? AssetImage("assets/images/person.png")
                                  : FileImage(File(controller.selectedImage!.path)),
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
                    SizedBox(height: AppSizes.pw8),
                    Text(
                      PreferencesManager().getString("user_email") ?? "",
                      style: TextStyle(color: Colors.black, fontSize: AppSizes.sp16),
                    ),

                    ListTile(
                      title: Text("Personal Info"),
                      leading: Icon(Icons.person),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showImageSourceDialog(BuildContext context) {
    final controller = context.read<ProfileController>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Select Image Source", style: TextStyle(fontSize: AppSizes.sp16)),

          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.camera);
              },
              padding: EdgeInsets.all(AppSizes.pw16),
              child: Row(children: [Icon(Icons.camera_alt), SizedBox(width: AppSizes.pw8), Text("Camera")]),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.gallery);
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
