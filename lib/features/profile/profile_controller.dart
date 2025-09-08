import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/core/mixins/safe_notify_mixin.dart';

class ProfileController extends ChangeNotifier with SafeNotify {
  XFile? selectedImage;

  String? userName;

  void pickImage(ImageSource source) async {
    selectedImage = await ImagePicker().pickImage(source: source);

    safeNotify();
  }

  getUserData() {
    userName = PreferencesManager().getString("username") ?? "";
    safeNotify();
  }
}
