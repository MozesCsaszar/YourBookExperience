import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbookexperience/common/theme/colors.dart';

class ThemeBuilder {
  static ThemeData getThemeData() {
    var attr = ThemeAttributes();
    return ThemeData(
      primaryColor: AppColors.foreground2,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.foreground2,
          secondary: AppColors.background,
          // tertiary: AppColors.tertiary,
          // surface: AppColors.surface,
          error: AppColors.red),
      brightness: Brightness.light,
      // elevatedButtonTheme: attr.elevatedButtonThemeData,
      // inputDecorationTheme: attr.inputDecorationTheme,
      textTheme: attr.textTheme,
      appBarTheme: attr.appBarTheme,
      textButtonTheme: attr.textButtonThemeData,
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}

class ThemeAttributes {
  ThemeAttributes();
  static const double _radius = 12;

  get textTheme {
    var background = AppColors.background;
    var text = AppColors.text;
    return GoogleFonts.robotoTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          color: background,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          color: background,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          color: background,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          color: background,
          fontWeight: FontWeight.w800,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          color: background,
          fontWeight: FontWeight.w800,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          color: background,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          color: background,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          color: background,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          color: background,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          color: text,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          color: text,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          color: text,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: text,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: text,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: text,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  get colorScheme => const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.foreground2,
      onPrimary: AppColors.background,
      secondary: AppColors.foreground1,
      onSecondary: AppColors.text,
      error: AppColors.red,
      onError: AppColors.text,
      background: AppColors.background,
      onBackground: AppColors.text,
      surface: AppColors.foreground2,
      onSurface: AppColors.background);

  get textButtonThemeData => TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 14,
                letterSpacing: 0.1,
                foreground: Paint()..color = AppColors.foreground2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );

  get appBarTheme => const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        color: AppColors.foreground2,
        iconTheme: IconThemeData(color: AppColors.background),
      );

  // get elevatedButtonThemeData => ElevatedButtonThemeData(
  //       style: ButtonStyle(
  //         elevation: MaterialStateProperty.all(0),
  //         textStyle: MaterialStateProperty.all(
  //           textTheme.bodyLarge.copyWith(
  //             foreground: Paint()..color = AppColors.foreground2,
  //           ),
  //         ),
  //         backgroundColor: MaterialStateProperty.resolveWith(
  //           (states) {
  //             if (states.contains(MaterialState.disabled)) {
  //               return AppColors.tertiary;
  //             }
  //             return AppColors.primary;
  //           },
  //         ),
  //         fixedSize:
  //             MaterialStateProperty.all(const Size(double.maxFinite, 42)),
  //         shape: MaterialStateProperty.all(
  //           RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(_radius),
  //           ),
  //         ),
  //       ),
  //     );

  // get inputDecorationTheme => InputDecorationTheme(
  //       filled: true,
  //       fillColor: AppColors.white,
  //       focusColor: AppColors.primary,
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       hintStyle: textTheme.bodyLarge.copyWith(
  //         foreground: Paint()..color = AppColors.secondary,
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(_radius),
  //         borderSide: BorderSide.none,
  //       ),
  //       disabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(_radius),
  //         borderSide: BorderSide.none,
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(_radius),
  //         borderSide: const BorderSide(color: AppColors.primary),
  //       ),
  //       errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(_radius),
  //         borderSide: const BorderSide(color: AppColors.error),
  //       ),
  //       focusedErrorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(_radius),
  //         borderSide: const BorderSide(color: AppColors.error),
  //       ),
  //       errorStyle: textTheme.labelSmall.copyWith(
  //         color: AppColors.error,
  //         fontWeight: FontWeight.w400,
  //       ),
  //     );
}
