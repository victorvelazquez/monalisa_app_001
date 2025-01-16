import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const scaffoldBackgroundColor = Colors.white;
const loginBackgroundColor = Color.fromARGB(255, 220, 220, 220);
const colorSeed = Color.fromRGBO(0, 19, 91, 1);

const cancelButtonColor = Color.fromRGBO(169, 169, 169, 1);
const editButtonColor = Color.fromRGBO(255, 193, 7, 1);
const deleteButtonColor = Color.fromRGBO(244, 67, 54, 1);

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
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
      ));
}
