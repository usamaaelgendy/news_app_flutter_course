import 'package:flutter/foundation.dart';

mixin SafeNotify on ChangeNotifier {
  bool isDispose = false;

  safeNotify() {
    if (!isDispose) notifyListeners();
  }

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }
}
