import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta de colores del proyecto Hotel App
class AppColors {
  AppColors._();

  /// Naranja principal — color de marca
  static const Color primary = Color(0xFFFF661A);

  /// Gris claro — fondo principal en modo claro
  static const Color backgroundLight = Color(0xFFF0F0F0);

  /// Gris oscuro — fondo en modo oscuro / texto principal
  static const Color backgroundDark = Color(0xFF303030);

  /// Durazno/salmón claro — color secundario / acentos
  static const Color secondary = Color(0xFFEFB49F);

  /// Blanco humo — superficies / tarjetas en modo claro
  static const Color surface = Color(0xFFF2F2F2);

  /// Verde — color de éxito
  static const Color success = Color(0xFF4CAF50);
}

/// Clase que gestiona el tema de la aplicación.
/// Soporta modo claro y oscuro con la misma paleta de colores.
class AppTheme {
  final bool isDarkMode;

  const AppTheme({this.isDarkMode = false});

  /// TextTheme base con Poppins para modo claro (texto oscuro sobre fondo claro).
  static final TextTheme _poppinsLight = GoogleFonts.poppinsTextTheme(
    ThemeData(brightness: Brightness.light).textTheme,
  );

  /// TextTheme base con Poppins para modo oscuro (texto claro sobre fondo oscuro).
  static final TextTheme _poppinsDark = GoogleFonts.poppinsTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  );

  ThemeData getTheme() => isDarkMode ? _darkTheme : _lightTheme;

  // ─────────────────────────────── Tema Claro ──────────────────────────────
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: _poppinsLight,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      // Primario
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.secondary,
      onPrimaryContainer: AppColors.backgroundDark,
      // Secundario
      secondary: AppColors.secondary,
      onSecondary: AppColors.backgroundDark,
      secondaryContainer: Color(0xFFFFDDD0),
      onSecondaryContainer: AppColors.backgroundDark,
      // Superficie
      surface: AppColors.surface,
      onSurface: AppColors.backgroundDark,
      surfaceContainerHighest: AppColors.backgroundLight,
      onSurfaceVariant: Color(0xFF555555),
      // Error
      error: Color(0xFFB00020),
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      // Outline
      outline: Color(0xFFBDBDBD),
      outlineVariant: Color(0xFFE0E0E0),
      // Misc
      shadow: Colors.black26,
      scrim: Colors.black54,
      inverseSurface: AppColors.backgroundDark,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.secondary,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.surface,
    dividerColor: const Color(0xFFE0E0E0),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
  );

  // ─────────────────────────────── Tema Oscuro ─────────────────────────────
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: _poppinsDark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      // Primario
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF8C3000),
      onPrimaryContainer: AppColors.secondary,
      // Secundario
      secondary: AppColors.secondary,
      onSecondary: AppColors.backgroundDark,
      secondaryContainer: Color(0xFF5D3728),
      onSecondaryContainer: AppColors.secondary,
      // Superficie
      surface: Color(0xFF1E1E1E),
      onSurface: AppColors.backgroundLight,
      surfaceContainerHighest: AppColors.backgroundDark,
      onSurfaceVariant: Color(0xFFBDBDBD),
      // Error
      error: Color(0xFFCF6679),
      onError: Colors.black,
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      // Outline
      outline: Color(0xFF555555),
      outlineVariant: Color(0xFF404040),
      // Misc
      shadow: Colors.black54,
      scrim: Colors.black87,
      inverseSurface: AppColors.backgroundLight,
      onInverseSurface: AppColors.backgroundDark,
      inversePrimary: Color(0xFF8C3000),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: AppColors.backgroundDark,
    dividerColor: const Color(0xFF404040),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.backgroundLight,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF555555)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
  );
}
