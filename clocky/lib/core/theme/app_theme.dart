import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryLight = Color(0xFF2196F3);  // Blue
  static const _primaryDark = Color(0xFF64B5F6);   // Light Blue
  
  static final _lightColorScheme = ColorScheme.fromSeed(
    seedColor: _primaryLight,
    brightness: Brightness.light,
  );

  static final _darkColorScheme = ColorScheme.fromSeed(
    seedColor: _primaryDark,
    brightness: Brightness.dark,
  );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightColorScheme.primaryContainer,
        foregroundColor: _lightColorScheme.onPrimaryContainer,
      ),
      cardTheme: CardThemeData(
        color: _lightColorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: _lightColorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _lightColorScheme.primary,
        foregroundColor: _lightColorScheme.onPrimary,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: _lightColorScheme.primary,
        unselectedLabelColor: _lightColorScheme.onSurfaceVariant,
        indicatorColor: _lightColorScheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: _lightColorScheme.surface,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkColorScheme.primaryContainer,
        foregroundColor: _darkColorScheme.onPrimaryContainer,
      ),
      cardTheme: CardThemeData(
        color: _darkColorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: _darkColorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: _darkColorScheme.primary,
        unselectedLabelColor: _darkColorScheme.onSurfaceVariant,
        indicatorColor: _darkColorScheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: _darkColorScheme.surface,
      ),
    );
  }
}