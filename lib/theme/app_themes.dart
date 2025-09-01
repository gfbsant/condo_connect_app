import 'package:flutter/material.dart';

class AppThemes {
  static const Color verdeTurquesa = Color(0xFF1ABC9C); // primário
  static const Color laranjaCoral = Color(0xFFFF6F3C); // secundário
  static const Color cinzaEscuro = Color(0xFF2C3E50);
  static const Color neutroClaro = Color(0xFFECF0F1);
  static const Color verdeEscuro = Color(0xFF16A085);
  static const Color laranjaEscuro = Color(0xFFE74C3C);
  static const Color cinzaMedio = Color(0xFF7F8C8D);

  // -------------------------------
  // Tema claro
  // -------------------------------
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: verdeTurquesa,
      secondary: laranjaCoral,
      surface: Colors.white,
      onSurface: cinzaEscuro,
      error: laranjaEscuro,
      onError: Colors.white,
    ),
  );

  // -------------------------------
  // Tema escuro
  // -------------------------------
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: laranjaCoral,
      secondary: verdeTurquesa,
      surface: Colors.black,
      onSecondary: Colors.black,
      onSurface: neutroClaro,
      error: laranjaEscuro,
      onError: Colors.white,
    ),
  );
}
