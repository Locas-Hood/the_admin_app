import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.ivoryMistLight,
      textTheme: GoogleFonts.tajawalTextTheme(base.textTheme),
      primaryTextTheme: GoogleFonts.tajawalTextTheme(base.primaryTextTheme),
      colorScheme: const ColorScheme.light(
        primary: AppColors.forest,
        secondary: AppColors.goldenWheat,
        surface: Color.fromARGB(255, 85, 54, 54),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.forest,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.forest,
        unselectedItemColor: AppColors.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightCardBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.middleGreen,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.emeraldShadowDark,
      textTheme: GoogleFonts.tajawalTextTheme(base.textTheme),
      primaryTextTheme: GoogleFonts.tajawalTextTheme(base.primaryTextTheme),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.forestLight,
        secondary: AppColors.goldenWheat,
        surface: AppColors.emeraldShadow,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.emeraldShadow,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.emeraldShadow,
        selectedItemColor: AppColors.goldenWheat,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkCardBorder, width: 1),
        ),
      ),
    );
  }
}
