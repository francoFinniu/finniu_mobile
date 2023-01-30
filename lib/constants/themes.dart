import 'package:finniu/widgets/fonts.dart';
import 'package:flutter/material.dart';
import 'package:finniu/constants/colors.dart';

class AppTheme {
  get darkTheme => ThemeData(
        // primarySwatch:,
        appBarTheme: const AppBarTheme(color: Color(primaryDark)),
        backgroundColor: const Color(backgroundColorDark),
        primaryColor: const Color(primaryDark), // usado para gradiente
        primaryColorLight: const Color(primaryLight), // usado para gradiente
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Color(sky_blue_text),
          ),
          titleMedium: TextStyle(
            color: Color(hintTextDarkColor),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(primaryLight),
          // tertiary: Color(0xff164D7D),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Color(borderInputDarkColor),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Color(borderInputDarkColor),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Color(borderInputLightColor),
            ),
          ),
          hintStyle: fontPoppins(
            fontSize: 11,
            colorHex: hintTextDarkColor,
            fontWeight: FontWeight.w600,
          ),
          labelStyle: fontInter(
            fontSize: 12,
            colorHex: labelTextDarkColor,
            fontWeight: FontWeight.w600,
          ),
          suffixIconColor: const Color(suffixIconDarkColor),
        ),
      );

  get lightTheme => ThemeData(
        // primarySwatch: Colors.grey,
        backgroundColor: const Color(backgroundColorLight),
        primaryColor: const Color(primaryLight), // usado para gradiente
        primaryColorLight: const Color(secondary), // usado para gradiente
        appBarTheme: const AppBarTheme(color: Color(primaryLight)),

        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Color(blackText),
          ),
          titleMedium: TextStyle(
            color: Color(hintTextLightColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Color(borderInputLightColor),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Color(borderInputLightColor),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Color(borderInputLightColor),
            ),
          ),
          hintStyle: fontPoppins(
            fontSize: 11,
            colorHex: hintTextLightColor,
            fontWeight: FontWeight.w600,
          ),
          labelStyle: fontInter(
            fontSize: 12,
            colorHex: labelTextLightColor,
            fontWeight: FontWeight.w600,
          ),
          suffixIconColor: const Color(suffixIconColorLight),
        ),

        colorScheme: const ColorScheme.dark(
          primary: Colors.black,
          secondary: Color(primaryDark),
          // tertiary: Color(0xffA2E6FA),
        ),
      );
}
