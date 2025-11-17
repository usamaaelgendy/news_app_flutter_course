import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/datasource/local_data/user_repository.dart';
import 'package:news_app/core/models/user_model.dart';
import 'package:news_app/core/widgets/custom_text_form_field.dart';

class ProfileInfoBottomSheet extends StatefulWidget {
  const ProfileInfoBottomSheet({super.key});

  @override
  State<ProfileInfoBottomSheet> createState() => _ProfileInfoBottomSheetState();
}

class _ProfileInfoBottomSheetState extends State<ProfileInfoBottomSheet> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  void _loadUserData() {
    final UserModel user = UserRepository().getUser();
    emailController.text = user.email ?? "";
    usernameController.text = user.name ?? "";
  }

  void _saveUserData() async {
    if (_key.currentState?.validate() ?? false) {
      await UserRepository().updateUser(
        name: usernameController.text,
        email: emailController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.r16),
          topRight: Radius.circular(AppSizes.r16),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: AppSizes.w42,
                    height: AppSizes.h4,
                    decoration: BoxDecoration(
                      color: Color(0xFF363636),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),

                SizedBox(height: AppSizes.ph16),
                Text(
                  "Profile Info",
                  style: TextStyle(fontSize: AppSizes.sp16, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: AppSizes.ph16),

                CustomTextFormField(
                  controller: usernameController,
                  hintText: 'Ahmed Ibrahim',
                  title: 'User Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter User Name";
                    }

                    return null;
                  },
                ),
                SizedBox(height: AppSizes.ph16),
                CustomTextFormField(
                  controller: emailController,
                  hintText: 'usama@gmail.com',
                  title: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Email";
                    }
                    RegExp emailRegExp = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );

                    if (!emailRegExp.hasMatch(value)) {
                      return 'Please Enter Valid Email';
                    } else {
                      return null;
                    }
                  },
                ),

                SizedBox(height: AppSizes.ph40),
                ElevatedButton(
                  onPressed: () {
                    _saveUserData();
                  },
                  child: Text("Save"),
                ),
                SizedBox(height: AppSizes.ph16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
