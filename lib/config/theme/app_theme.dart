import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const scaffoldBackgroundColor = Colors.white;
final backgroundColor = Colors.grey[300];
const colorSeed = Color.fromRGBO(20, 25, 45, 1);
const colorSeedLight = Color.fromRGBO(70, 85, 130, 1);
const editButtonColor = Color.fromRGBO(255, 170, 0, 1);
const deleteButtonColor = Color.fromRGBO(200, 30, 30, 1);
final cancelButtonColor = Colors.grey[600];

class AppTheme {
  ThemeData getTheme() => ThemeData(

      ///* General
      // useMaterial3: true,
      colorSchemeSeed: colorSeed,

      ///* Texts
      textTheme: TextTheme(
          titleLarge: GoogleFonts.roboto()
              .copyWith(fontSize: 35, fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.roboto()
              .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
          titleSmall: GoogleFonts.roboto().copyWith(fontSize: 14)),

      ///* Scaffold Background Color
      scaffoldBackgroundColor: scaffoldBackgroundColor,

      ///* Buttons
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  colorSeed),
              textStyle: WidgetStatePropertyAll(
                  GoogleFonts.roboto().copyWith(fontWeight: FontWeight.w700)))),

      ///* AppBar
      appBarTheme: AppBarTheme(
        color: scaffoldBackgroundColor,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto().copyWith(
            fontSize: 22, fontWeight: FontWeight.bold, color: colorSeed),
      ));
}
