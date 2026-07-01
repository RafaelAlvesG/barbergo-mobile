import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/hive/boxes.dart';

class ThemeProvider with ChangeNotifier {
  final Box _settingsBox = Hive.box(AppBoxes.settings);

  ThemeMode get themeMode {
    final isDark = _settingsBox.get('darkMode', defaultValue: false);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  Future<void> toggleTheme(bool isDark) async {
    await _settingsBox.put('darkMode', isDark);
    notifyListeners();
  }
}
