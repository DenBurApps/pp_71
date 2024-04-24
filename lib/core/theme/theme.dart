import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class DefaultTheme {
  static final dark = AppTheme(
    id: 'dark',
    data: ThemeData(
      scaffoldBackgroundColor: ligthColors.background,
      colorScheme: darkColors,
      textTheme: textTheme,
      extensions: const [CustomColors.value],
    ),
    description: 'App dark theme',
  );

  static final light = AppTheme(
    id: 'light',
    data: ThemeData(
      scaffoldBackgroundColor: darkColors.background,
      colorScheme: darkColors,
      textTheme: textTheme,
      extensions: const [CustomColors.value],
    ),
    description: 'App dark theme',
  );

  static ColorScheme darkColors = ColorScheme(
    brightness: Brightness.light,
    primary: const Color.fromRGBO(251, 255, 98, 1),
    onPrimary: const Color.fromRGBO(255, 255, 255, 255),
    secondary:  Colors.grey.withOpacity(0.2),
    onSecondary: const Color.fromRGBO(255, 255, 255, 1),
    error: Colors.red,
    onError: const Color.fromRGBO(255, 255, 0, 0),
    background: const Color.fromRGBO(20, 20, 20, 1),
    onBackground: const Color.fromRGBO(255, 255, 255, 1),
    surface: const  Color.fromRGBO(20, 20, 20, 1),
    onSurface: const Color.fromRGBO(255, 0, 0, 0),
    primaryContainer: const Color.fromRGBO(210, 59, 60, 1),
    onPrimaryContainer: const Color.fromRGBO(255, 255, 255, 255),
    shadow: Colors.grey,
  );

  static ColorScheme ligthColors = ColorScheme(
    brightness: Brightness.light,
    primary: const Color.fromARGB(255, 0, 0, 0),
    onPrimary: const Color.fromRGBO(23, 28, 33, 1),
    secondary: const Color.fromRGBO(59, 53, 43, 1),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    background: const Color.fromRGBO(253, 253, 252, 1),
    onBackground: Colors.black,
    surface: const Color.fromRGBO(245, 246, 253, 1),
    onSurface: Colors.black,
    primaryContainer: const Color.fromRGBO(119, 103, 80, 1).withOpacity(0.2),
    onPrimaryContainer: Colors.black,
    shadow: Colors.grey,
  );

  static final textTheme = TextTheme(
    displayLarge: GoogleFonts.josefinSans(
        fontSize: 23,
        fontWeight: FontWeight.w500,
        color: const Color.fromRGBO(255, 255, 255, 1),
      ),
    displayMedium: GoogleFonts.josefinSans(
      fontSize: 23,
      fontWeight: FontWeight.w600,
      color: const Color.fromRGBO(255, 255, 255, 1),
    ),
    displaySmall: GoogleFonts.josefinSans(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color.fromRGBO(255, 255, 255, 1),
        ),
    bodyLarge: GoogleFonts.josefinSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color.fromRGBO(255, 255, 255, 1),
    ),
    bodyMedium: GoogleFonts.josefinSans(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: const Color.fromRGBO(255, 255, 255, 1),
    ),
    bodySmall: GoogleFonts.josefinSans(
      fontSize: 15,
      fontWeight: FontWeight.w300,
      color: const Color.fromRGBO(255, 255, 255, 1),
    ),
    labelLarge: GoogleFonts.josefinSans(
      fontSize: 13,
      fontWeight: FontWeight.w300,
      color: const Color.fromRGBO(255, 255, 255, 1),
    ),
    labelMedium: GoogleFonts.josefinSans(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: const Color.fromRGBO(255, 255, 255, 1),
    ),
    labelSmall: GoogleFonts.josefinSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color.fromRGBO(255, 255, 255, 1),
    ),
    titleSmall: GoogleFonts.josefinSans(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: const Color.fromRGBO(255, 255, 255, 1),
    ),
    headlineMedium: GoogleFonts.josefinSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: const Color.fromRGBO(255, 255, 255, 1),
    ),
  );
}

class CustomColors extends ThemeExtension<CustomColors> {
  final Color green;
  final Color red;

  const CustomColors({
    required this.green,
    required this.red,
  });

  @override
  CustomColors copyWith({
    Color? green,
    Color? red,
  }) {
    return CustomColors(
      green: green ?? this.green,
      red: red ?? this.red,
    );
  }

  static const value = CustomColors(
    green: Color(0xFFB5FFB4),
    red: Color(0xFFEE8787),
  );

  @override
  ThemeExtension<CustomColors> lerp(
      covariant ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      green: Color.lerp(green, other.green, t)!,
      red: Color.lerp(red, other.red, t)!,
    );
  }
}

Color getColorFromRGBString(String rgbString) {
  if (rgbString.startsWith('-')) {
    return const Color.fromRGBO(233, 93, 92, 1);
  } else {
    return const Color.fromRGBO(79, 205, 68, 1);
  }
}
