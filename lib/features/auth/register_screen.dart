import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/core/datasource/local_data/user_repository.dart';
import 'package:news_app/core/widgets/custom_text_form_field.dart';
import 'package:news_app/features/main/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  void register() async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    final String? error = await UserRepository().signUp(
      name: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    if (error != null) {
      setState(() {
        errorMessage = error;
        isLoading = false;
      });
      return;
    }
    await PreferencesManager().setBool("is_logged_in", true);

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const MainScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/background_image.png")),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.r16),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset("assets/images/logo.png", height: AppSizes.h45),
                    ),
                    SizedBox(height: AppSizes.ph40),
                    Text(
                      "Welcome to Newts",
                      style: TextStyle(
                        fontSize: AppSizes.sp20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSizes.ph24),
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
                    SizedBox(height: AppSizes.ph24),
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
                    SizedBox(height: AppSizes.ph24),
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
                    SizedBox(height: AppSizes.ph24),
                    CustomTextFormField(
                      controller: confirmPasswordController,
                      hintText: '*************',
                      title: 'Confirm Password',
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
                          if (_formKey.currentState?.validate() ?? false) {
                            register();
                          }
                        },
                        child:
                            isLoading
                                ? const CircularProgressIndicator()
                                : const Text("Sign Up"),
                      ),
                    ),
                    SizedBox(height: AppSizes.ph24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have an account ?",
                          style: TextStyle(fontSize: AppSizes.sp14),
                        ),
                        SizedBox(width: AppSizes.pw8),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Sign In",
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
    );
  }
}
