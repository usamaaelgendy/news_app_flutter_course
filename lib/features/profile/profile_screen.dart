import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/core/datasource/local_data/user_repository.dart';
import 'package:news_app/core/theme/light_color.dart';
import 'package:news_app/core/widgets/custom_svg_picture.dart';
import 'package:news_app/features/auth/login_screen.dart';
import 'package:news_app/features/profile/bottom_sheet/profile_info_bottom_sheet.dart';
import 'package:news_app/features/profile/profile_controller.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileController>(
      create: (BuildContext context) => ProfileController()..getUserData(),
      child: Scaffold(
        appBar: AppBar(title: Text("Profile"), centerTitle: true),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.h24, horizontal: AppSizes.w16),
          child: Consumer<ProfileController>(
            builder: (BuildContext context, ProfileController controller, Widget? child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
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
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(Icons.camera_alt),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.ph8),
                    Center(
                      child: Text(
                        controller.userName ?? "",
                        style: TextStyle(color: Colors.black, fontSize: AppSizes.sp16),
                      ),
                    ),

                    SizedBox(height: AppSizes.ph16),

                    _buildProfileItem(
                      "Personal Info",
                      "assets/images/profile.svg",
                      () async {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return ProfileInfoBottomSheet();
                          },
                        ).then((value) {
                          controller.getUserData();
                        });
                      },
                    ),
                    _buildProfileItem("Language", "assets/images/language.svg", () {}),
                    _buildProfileItem(controller.countryName ?? "Country", "assets/images/country.svg", () {
                      showCountryPicker(
                        context: context,
                        onSelect: (Country country) {
                          controller.saveCountry(country);
                        },
                      );
                    }),
                    _buildProfileItem(
                      "Terms & Conditions",
                      "assets/images/terms_conditions.svg",
                      () {},
                    ),
                    _buildProfileItem(
                      "Logout",
                      "assets/images/logout.svg",
                      () async {
                        // Clear user data from Hive
                        await UserRepository().delete();
                        // Clear login flags from SharedPreferences
                        await PreferencesManager().clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      },
                      color: LightColors.primaryColor,
                      withDivider: false,
                    ),
                  ],
                ),
              );
            },
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
              child: Row(
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: AppSizes.pw8),
                  Text("Camera"),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.gallery);
              },
              padding: EdgeInsets.all(AppSizes.pw16),
              child: Row(
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: AppSizes.pw8),
                  Text("Galley"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileItem(
    String title,
    String path,
    Function onTap, {
    Color color = const Color(0xFF161F1B),
    bool withDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: () => onTap(),
          title: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w400,
              fontSize: AppSizes.sp16,
            ),
          ),
          leading: CustomSvgPicture.withoutColor(path: path),
          trailing: CustomSvgPicture.withoutColor(
            path: "assets/images/arrow.svg",
            height: AppSizes.w16,
            width: AppSizes.w16,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: AppSizes.pw8),
        ),

        if (withDivider) Divider(color: Colors.grey.shade500),
      ],
    );
  }
}
