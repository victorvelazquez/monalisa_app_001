import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const themeColorPrimary = Color.fromRGBO(25, 35, 70, 1);
const themeColorPrimaryLight = Color.fromRGBO(140, 150, 255, 1);

const themeBackgroundColor = Colors.white;
const themeBackgroundColorLight = Color.fromRGBO(230, 230, 230, 1);

const themeColorSuccessful = Color.fromRGBO(70, 170, 70, 1);
const themeColorSuccessfulLight = Color.fromRGBO(140, 220, 140, 1);
const themeColorWarning = Color.fromRGBO(250, 200, 50, 1);
const themeColorWarningLight = Color.fromRGBO(250, 220, 120, 1);
const themeColorError = Color.fromRGBO(255, 50, 50, 1);
const themeColorErrorLight = Color.fromRGBO(255, 100, 100, 1);
const themeFontColorDarkGray = Color.fromRGBO(66, 66, 66, 1);
const themeFontColorDarkGrayLight = Color.fromRGBO(117, 117, 117, 1);

const double themeFontSizeLarge = 16;
const double themeFontSizeNormal = 14;
const double themeFontSizeSmall = 12;
const double themeFontSizeTitle = 22;

const double themeBorderRadius = 20;

class AppTheme {
  ThemeData getTheme() => ThemeData(

      ///* General
      // useMaterial3: true,
      colorSchemeSeed: themeColorPrimary,

      ///* Texts
      textTheme: TextTheme(
          titleLarge: GoogleFonts.roboto()
              .copyWith(fontSize: 35, fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.roboto()
              .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
          titleSmall: GoogleFonts.roboto().copyWith(fontSize: themeFontSizeNormal)),

      ///* Scaffold Background Color
      scaffoldBackgroundColor: themeBackgroundColor,

      ///* Buttons
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(themeColorPrimary),
              textStyle: WidgetStatePropertyAll(
                  GoogleFonts.roboto().copyWith(fontWeight: FontWeight.w700)))),

      ///* AppBar
      appBarTheme: AppBarTheme(
        color: themeBackgroundColor,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto().copyWith(
            fontSize: themeFontSizeTitle, fontWeight: FontWeight.bold, color: themeColorPrimary),
      ));
}
