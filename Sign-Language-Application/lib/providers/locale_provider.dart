import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('fr'); // Default to French

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Method to switch to Arabic
  void switchToArabic() {
    setLocale(const Locale('ar'));
  }
}