import "package:flutter/material.dart";

class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn){
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

}


class MyThemes{
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: const ColorScheme.dark(),
    primaryColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.purple.shade200,opacity:0.8)
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(),
    primaryColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.red, opacity:0.8)
  );
}