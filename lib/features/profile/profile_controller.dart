import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/core/mixins/safe_notify_mixin.dart';

class ProfileController extends ChangeNotifier with SafeNotify {
  XFile? selectedImage;

  String? userName;
  String? countryCode;
  String? countryName;

  void pickImage(ImageSource source) async {
    selectedImage = await ImagePicker().pickImage(source: source);

    safeNotify();
  }

  getUserData() {
    userName = PreferencesManager().getString("username") ?? "";
    countryName = PreferencesManager().getString("country_name") ?? "";
    countryCode = PreferencesManager().getString("country_code") ?? "";
    safeNotify();
  }

  void saveCountry(Country selectedCountry) async {
    await PreferencesManager().setString("country_name", selectedCountry.name);
    await PreferencesManager().setString("country_code", selectedCountry.countryCode);
    countryName = selectedCountry.name;
    countryCode = selectedCountry.countryCode;

    safeNotify();
  }
}
