import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const verdeTurquesa = Color(0xFF1ABC9C);
  static const laranjaCoral = Color(0xFFFF6F3C);
  static const cinzaEscuro = Color(0xFF2C3E50);
  static const neutroClaro = Color(0xFFECF0F1);
  static const laranjaEscuro = Color(0xFFE74C3C);
  static const cinzaMedio = Color(0xFF7F8C8D);

  static final TextTheme _baseTextTheme = GoogleFonts.poppinsTextTheme();

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: verdeTurquesa,
      primary: verdeTurquesa,
      secondary: laranjaCoral,
      error: laranjaEscuro,
      surface: Colors.white,
    ),
    textTheme: _baseTextTheme.copyWith(
      headlineMedium: _baseTextTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: cinzaEscuro,
      ),
      bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
        color: cinzaEscuro.withAlpha(204),
      ),
    ),
    elevatedButtonTheme: _elevatedButtonTheme(verdeTurquesa, Colors.white),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: verdeTurquesa,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: neutroClaro,
      borderColor: cinzaMedio,
      focusColor: verdeTurquesa,
      labelColor: cinzaEscuro,
      iconColor: cinzaMedio,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: laranjaEscuro,
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: laranjaCoral,
      primary: laranjaCoral,
      secondary: verdeTurquesa,
      error: laranjaEscuro,
      surface: const Color(0xFF121212),
      brightness: Brightness.dark,
    ),
    textTheme: _baseTextTheme
        .apply(
          bodyColor: neutroClaro,
          displayColor: neutroClaro,
        )
        .copyWith(
          headlineMedium: _baseTextTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: neutroClaro,
          ),
          bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
            color: neutroClaro.withAlpha(204),
          ),
        ),
    elevatedButtonTheme: _elevatedButtonTheme(laranjaCoral, cinzaEscuro),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: laranjaCoral,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: cinzaEscuro,
      borderColor: cinzaMedio,
      focusColor: cinzaMedio,
      labelColor: neutroClaro,
      iconColor: neutroClaro.withAlpha(179),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: laranjaEscuro,
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
  );

  static ElevatedButtonThemeData _elevatedButtonTheme(
    final Color background,
    final Color foreground,
  ) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static InputDecorationTheme _inputDecorationTheme({
    required final Color fillColor,
    required final Color borderColor,
    required final Color focusColor,
    required final Color labelColor,
    required final Color iconColor,
  }) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fillColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: laranjaEscuro, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: laranjaEscuro, width: 2),
        ),
        labelStyle: TextStyle(color: labelColor),
        prefixIconColor: iconColor,
      );
}
