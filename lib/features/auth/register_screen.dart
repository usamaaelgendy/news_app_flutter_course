import 'package:flutter/material.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/core/widgets/custom_text_form_field.dart';
import 'package:news_app/features/main/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

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

    await Future.delayed(Duration(seconds: 3));

    final savedEmail = PreferencesManager().getString("user_email");

    if (savedEmail != null && savedEmail == emailController.text.trim()) {
      setState(() {
        errorMessage = "User Already Registered";
        isLoading = false;
      });
    } else {
      await PreferencesManager().setString("user_email", emailController.text);
      await PreferencesManager().setString("user_password", passwordController.text);
      await PreferencesManager().setBool("is_logged_in", true);

      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return MainScreen();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background_image.png"))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("assets/images/logo.png", height: 45)),
                SizedBox(height: 40),
                Text("Welcome to Newts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: 24),
                CustomTextFormField(
                  controller: emailController,
                  hintText: 'usama@gmail.com',
                  title: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Email";
                    }
                    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                    if (!emailRegExp.hasMatch(value)) {
                      return 'Please Enter Valid Email';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 24),
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
                SizedBox(height: 24),
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
                  ),

                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        register();
                      }
                    },
                    child: isLoading ? CircularProgressIndicator() : Text("Sign Up"),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account ?", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text("Sign In", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
