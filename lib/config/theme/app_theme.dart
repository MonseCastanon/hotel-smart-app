import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Paleta de colores
// ─────────────────────────────────────────────────────────────────────────────

/// Colores globales de la Smart TV.
///
/// Los colores de estado coinciden con los mockups y el mapa usado en
/// [RoomModel] y [StatusBadge]:
///   • [occupied]  → naranja  (Ocupada / alerta)
///   • [clean]     → verde    (Limpia)
///   • [dirty]     → rojo     (Sucia)
///   • [cleaning]  → azul     (En Limpieza)
///
/// El color [primary] (naranja de marca) se reutiliza del proyecto
/// [hotel_app] para mantener consistencia visual entre ambas apps.
abstract final class AppColors {
  // ── Marca ─────────────────────────────────────────────────────────────────
  /// Naranja principal — botón Check-In, ícono de notificaciones, acento.
  static const Color primary = Color(0xFFFF661A);

  /// Variante más oscura del naranja para hover / pressed.
  static const Color primaryDark = Color(0xFFCC4A00);

  // ── Fondos ────────────────────────────────────────────────────────────────
  /// Fondo general de la app (pantalla oscura, TV).
  static const Color background = Color(0xFF0F1117);

  /// Superficie de tarjetas y paneles.
  static const Color surface = Color(0xFF1C1F2A);

  /// Superficie elevada (modales, dropdowns).
  static const Color surfaceElevated = Color(0xFF252836);

  // ── Texto ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF2F3F7);
  static const Color textSecondary = Color(0xFF9EA3B2);
  static const Color textDisabled = Color(0xFF555A6B);

  // ── Bordes ────────────────────────────────────────────────────────────────
  static const Color border = Color(0xFF2E3245);
  static const Color borderFocus = Color(0xFFFF661A); // naranja al enfocar

  // ── Estados de habitación ─────────────────────────────────────────────────
  /// Habitación Ocupada
  static const Color occupied = Color(0xFFFF8C00);

  /// Habitación Limpia
  static const Color clean = Color(0xFF2ECC71);

  /// Habitación Sucia
  static const Color dirty = Color(0xFFE74C3C);

  /// Habitación En Limpieza
  static const Color cleaning = Color(0xFF3498DB);

  // ── Semánticos generales ──────────────────────────────────────────────────
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFFF8C00);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);
}

// ─────────────────────────────────────────────────────────────────────────────
// Tema principal
// ─────────────────────────────────────────────────────────────────────────────

/// Clase que construye el [ThemeData] para la Smart TV.
///
/// Pensado para verse bien en pantallas grandes a distancia:
///   • Contraste alto (texto claro sobre fondo muy oscuro).
///   • Tipografía grande y legible (Poppins, tamaños aumentados).
///   • Modo único: siempre oscuro (TV nunca cambia de tema).
class AppTheme {
  const AppTheme();

  ThemeData getTheme() => _theme;

  static final ThemeData _theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.surface,
    dividerColor: AppColors.border,

    // ── Tipografía ──────────────────────────────────────────────────────────
    // Poppins igual que hotel_app; tamaños más grandes para TV.
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).copyWith(
      // Títulos de sección (ej. "Habitaciones Disponibles")
      headlineMedium: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.3,
      ),
      // Subtítulos y labels de tarjeta
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      // Cuerpo de texto principal
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      // Labels pequeños (ej. tiempo en notificaciones)
      labelSmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textDisabled,
        letterSpacing: 0.5,
      ),
    ),

    // ── ColorScheme ─────────────────────────────────────────────────────────
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.occupied,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF3A2000),
      onSecondaryContainer: AppColors.occupied,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceElevated,
      onSurfaceVariant: AppColors.textSecondary,
      error: AppColors.dirty,
      onError: Colors.white,
      errorContainer: Color(0xFF4A0F0F),
      onErrorContainer: AppColors.dirty,
      outline: AppColors.border,
      outlineVariant: Color(0xFF1E2130),
      shadow: Colors.black54,
      scrim: Colors.black87,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.background,
      inversePrimary: AppColors.primaryDark,
    ),

    // ── AppBar ──────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
    ),

    // ── Botones elevados ─────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // ── Cards ────────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── Iconos ───────────────────────────────────────────────────────────────
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: 24,
    ),
  );
}
