import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────
/// PALETA DE COLORES DE LA APP (Tema Dark)
///
/// Punto único de verdad para todos los colores de la aplicación.
/// Ninguna vista/widget debería declarar un Color.fromARGB / Colors.xxx
/// "suelto": todo se referencia desde aquí para poder cambiar el
/// look & feel completo editando solo este archivo.
/// ─────────────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // ── Colores base del ColorScheme ─────────────────────────────────────
  static const Color primary = Color.fromARGB(255, 232, 231, 231);
  static const Color secondary = Color.fromARGB(255, 52, 157, 119);
  static const Color background = Color.fromARGB(255, 13, 13, 15);
  static const Color surface = Color.fromARGB(255, 27, 25, 25);
  static const Color error = Color.fromARGB(255, 211, 47, 47);

  // ── Overlays / fondos semitransparentes ──────────────────────────────
  // Usado en los "chips" de título sobre las pantallas (Fondopantalla).
  static final Color overlay = Colors.black.withOpacity(0.6);

  // ── Texto ─────────────────────────────────────────────────────────────
  static const Color textPrimary = Colors.white;
  static const Color textTitle = Color.fromARGB(223, 255, 154, 60);
  static const Color textSubtitle = secondary;

  // ── Botones (texto → forma píldora) ──────────────────────────────────
  static const Color buttonBackground = secondary;
  static const Color buttonForeground = Color.fromARGB(223, 4, 4, 4);
  static const Color outlineButtonForeground = textPrimary;

  // ── Selector de clave musical (configuración) ────────────────────────
  static const Color chipSelectedBackground = primary;
  static const Color chipUnselectedBackground = Color.fromARGB(255, 63, 216, 33);
  static const Color chipUnselectedBorder = Color.fromARGB(255, 239, 237, 237);
  static const Color chipSelectedText = Color.fromARGB(255, 27, 25, 25);
  static const Color chipUnselectedText = Colors.black87;

  // ── Feedback de respuestas del juego ─────────────────────────────────
  static const Color success = Colors.green;
  static const Color danger = Colors.red;

  // ── Pentagrama (fondo tipo "papel" + tinta) ──────────────────────────
  static final Color staffBackground = Colors.white.withOpacity(0.92);
  static const Color staffInk = Colors.black87;
  static const Color staffInkStrong = Colors.black;

  // ── Botones de respuesta sobre el pentagrama (alto contraste) ────────
  static const Color answerButtonBackground = Colors.white;
  static const Color answerButtonForeground = Colors.black87;
}

/// Radio de las esquinas para tarjetas/paneles no interactivos
/// (no botones), p. ej. el contenedor del pentagrama.
const double kPanelRadius = 20;

/// ─────────────────────────────────────────────────────────────────────────
/// THEME DATA
/// ─────────────────────────────────────────────────────────────────────────
ThemeData get tema {
  // Forma común "píldora" para todos los botones con texto.
  const buttonShape = StadiumBorder();
  const buttonPadding = EdgeInsets.symmetric(horizontal: 28, vertical: 16);

  return ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.secondary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
      brightness: Brightness.dark,
    ),

    // Tipografía
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: AppColors.textTitle,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textSubtitle,
      ),
      bodyMedium: TextStyle(
        fontSize: 24,
        color: AppColors.textSubtitle,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ElevatedButton → píldora (botones principales: Jugar, Configuración...)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBackground.withOpacity(0.6),
        foregroundColor: AppColors.buttonForeground,
        shape: buttonShape,
        padding: buttonPadding,
      ),
    ),

    // OutlinedButton → misma forma, por si se usa en el futuro
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.outlineButtonForeground,
        side: const BorderSide(color: AppColors.buttonBackground, width: 2),
        shape: buttonShape,
        padding: buttonPadding,
      ),
    ),

    // TextButton → misma forma
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.buttonBackground,
        shape: buttonShape,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),

    // IconButton (ej. HomeButton) → círculo perfecto, ideal para iconos
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        shape: const CircleBorder(),
      ),
    ),

    // FloatingActionButton → círculo perfecto
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.buttonBackground,
      foregroundColor: AppColors.textPrimary,
      shape: CircleBorder(),
    ),
  );
}

/// Fondo compartido de todas las pantallas (imagen + color base).
class Fondopantalla extends StatelessWidget {
  final Widget child;

  const Fondopantalla({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        image: DecorationImage(
          image: AssetImage('assets/imagenes/Logo trasparente.png'),
          // fit: BoxFit.cover, // Para que la imagen cubra toda el área
        ),
      ),
      child: child,
    );
  }
}
