import 'package:flutter/material.dart';
import 'package:shop/src/theme/button_theme.dart';
import 'package:shop/src/theme/input_decoration_theme.dart';

import '../constants.dart';
import 'checkbox_themedata.dart';
import 'theme_data.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: "Montserrat",
      primarySwatch: primaryMaterialColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryMaterialColor,
        accentColor: primaryColor,
      ).copyWith(
        secondary: primaryColor,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      iconTheme: const IconThemeData(color: sandDuneColor),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: blackColor40),
      ),
      elevatedButtonTheme: elevatedButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(),
      inputDecorationTheme: lightInputDecorationTheme,
      checkboxTheme: checkboxThemeData.copyWith(
        side: const BorderSide(color: blackColor40),
      ),
      appBarTheme: appBarLightTheme,
      scrollbarTheme: scrollbarThemeData,
      dataTableTheme: dataTableLightThemeData,
      dialogTheme: DialogTheme.of(context).copyWith(
        backgroundColor: Colors.white,
      ),
    );
  }

  // Dark theme is inclided in the Full template
}
