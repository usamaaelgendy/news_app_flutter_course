import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/core/datasource/local_data/user_repository.dart';
import 'package:news_app/core/widgets/custom_text_form_field.dart';
import 'package:news_app/features/auth/register_screen.dart';
import 'package:news_app/features/main/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey();

  String? errorMessage;
  bool isLoading = false;

  void login() async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    final String? error = UserRepository().login(
      emailController.text,
      passwordController.text,
    );

    if (error != null) {
      setState(() {
        errorMessage = error;
        isLoading = false;
      });
      return;
    }

    await PreferencesManager().setBool("is_logged_in", true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const MainScreen();
        },
      ),
    );

    setState(() {
      errorMessage = null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_image.png"),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.r16),
            child: Form(
              key: _form,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: AppSizes.h45,
                        ),
                      ),
                      SizedBox(height: AppSizes.h40),
                      Text(
                        "Welcome to Newts",
                        style: TextStyle(
                          fontSize: AppSizes.sp20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),
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
                      SizedBox(height: AppSizes.h24),
                      CustomTextFormField(
                        controller: passwordController,
                        hintText: '*************',
                        title: 'Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Password";
                          }

                          return null;
                        },
                      ),

                      if (errorMessage != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSizes.ph8),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      SizedBox(height: AppSizes.ph24),
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.h48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_form.currentState?.validate() ?? false) {
                              login();
                            }
                          },
                          child:
                              isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text("Sign In"),
                        ),
                      ),
                      SizedBox(height: AppSizes.ph24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account ?",
                            style: TextStyle(fontSize: AppSizes.sp14),
                          ),
                          SizedBox(width: AppSizes.pw8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return const RegisterScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: AppSizes.sp16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
