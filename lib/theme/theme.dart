import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/core/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

final languageNotifierProvider =
    StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

// Class to manage language state
class LanguageNotifier extends StateNotifier<AppLanguage> {
  AppLanguage _language;

  LanguageNotifier({AppLanguage language = AppLanguage.marathi})
      : _language = language,
        super(language);

  AppLanguage get language => _language;

  Future<void> toggleLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_language == AppLanguage.english) {
      _language = AppLanguage.marathi;
      prefs.setString('language', 'marathi');
    } else {
      _language = AppLanguage.english;
      prefs.setString('language', 'english');
    }
    state = _language; // Update state after preference change
  }
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;

  ThemeNotifier({ThemeMode mode = ThemeMode.light})
      : _mode = mode,
        super(mode == ThemeMode.light ? ThemeData.light() : ThemeData.dark());

  ThemeMode get mode => _mode;

  Future<void> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = ThemeData.light();
    } else {
      _mode = ThemeMode.dark;
      state = ThemeData.dark();
    }
  }

  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = ThemeData.light();
      prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = ThemeData.dark();
      prefs.setString('theme', 'dark');
    }
  }
}

Color themeColor(BuildContext context) {
  final themeColor = Theme.of(context).brightness == Brightness.dark
      ? Colors.blue
      : Colors.amber;
  return themeColor;
}
