// File: lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors from Figma
  static const Color primaryPurple = Color(0xFF8E44AD);
  static const Color primaryLight = Color(0xFFA062BA);
  static const Color primaryLighter = Color(0xFFD6BCE1);
  static const Color secondaryYellow = Color(0xFFF7DC6F);
  
  // Basic Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color lightGray = Color(0xFFF9F9F9);
  static const Color textGray = Color(0xFF666666);
  
  // Gradient for Splash Screen
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF8E44AD),
      Color(0xFFA062BA),
      Color(0xFFB280C7),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  // Text Styles with fallbacks
  static TextStyle get logoLarge {
    try {
      return GoogleFonts.poppins(
        fontSize: 46,
        fontWeight: FontWeight.w600,
        color: white,
      );
    } catch (e) {
      return const TextStyle(
        fontSize: 46,
        fontWeight: FontWeight.w600,
        color: white,
        fontFamily: 'sans-serif',
      );
    }
  }
  
  static TextStyle get logoSmall {
    try {
      return GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: black,
      );
    } catch (e) {
      return const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: black,
        fontFamily: 'sans-serif',
      );
    }
  }
  
  static TextStyle get heading {
    try {
      return GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: black,
      );
    } catch (e) {
      return const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: black,
        fontFamily: 'sans-serif',
      );
    }
  }
  
  static TextStyle get body {
    try {
      return GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: black,
      );
    } catch (e) {
      return const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: black,
        fontFamily: 'sans-serif',
      );
    }
  }
  
  static TextStyle get buttonText {
    try {
      return GoogleFonts.merriweatherSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: white,
      );
    } catch (e) {
      return const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: white,
        fontFamily: 'sans-serif',
      );
    }
  }
  
  // App Theme
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: _createMaterialColor(primaryPurple),
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: white,
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        minimumSize: const Size(double.infinity, 59),
        // Remove textStyle reference that's causing the circular dependency
      ),
    ),
  );
  
  // Helper to create MaterialColor
  static MaterialColor _createMaterialColor(Color color) {
    Map<int, Color> swatch = {};
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    for (int i = 1; i <= 9; i++) {
      final double strength = i * 0.1;
      swatch[50 + (i * 100)] = Color.fromRGBO(
        red + ((255 - red) * (1 - strength)).round(),
        green + ((255 - green) * (1 - strength)).round(),
        blue + ((255 - blue) * (1 - strength)).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}