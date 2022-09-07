import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:taxinet/constants/themeprovider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(
        value: themeProvider.isDarkMode,
        onChanged: (value){
          final provider = Provider.of<ThemeProvider>(context,listen:false);
          provider.toggleTheme(value);
        }
    );
  }
  
}