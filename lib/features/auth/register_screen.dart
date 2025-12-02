import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/constants/app_sizes.dart';
import 'package:news_app/core/datasource/remote_data/api_service.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/core/widgets/custom_text_form_field.dart';
import 'package:news_app/features/auth/cubit/auth_cubit.dart';
import 'package:news_app/features/auth/repo/auth_repository.dart';
import 'package:news_app/features/main/main_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(AuthRepository(ApiService())),
      child: Scaffold(
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == RequestStatusEnum.loaded) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const MainScreen();
                  },
                ),
              );
            }
          },
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
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                "assets/images/logo.png",
                                height: AppSizes.h45,
                              ),
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

                            if (state.errorMessage != null)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: AppSizes.ph8),
                                child: Text(
                                  state.errorMessage!,
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
                                    context.read<AuthCubit>().register(
                                      name: usernameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                child:
                                    state.status == RequestStatusEnum.loading
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
