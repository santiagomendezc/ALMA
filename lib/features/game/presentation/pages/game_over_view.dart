import 'package:aplicacion/assets/colores/tema.dart';
import 'package:flutter/material.dart';

/// Pantalla de resultados que se muestra al terminar la partida
/// (al llegar a [GameProvider.maxErrors] errores).
class GameOverView extends StatelessWidget {
  final int correctCount;
  final int errorCount;
  final int score;
  final bool completed;
  final VoidCallback onRetry;
  final VoidCallback onGoToMenu;

  const GameOverView({
    super.key,
    required this.correctCount,
    required this.errorCount,
    required this.score,
    required this.onRetry,
    required this.onGoToMenu,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Fondopantalla(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: AppColors.overlay,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    completed
                        ? "¡Completaste todos los niveles!"
                        : "¡Juego terminado!",
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                _ResultRow(label: "Aciertos", value: "$correctCount"),
                const SizedBox(height: 12),
                _ResultRow(label: "Errores", value: "$errorCount"),
                const SizedBox(height: 12),
                _ResultRow(label: "Puntaje final", value: "$score", highlight: true),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text(" Volver a intentar "),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: onGoToMenu,
                  child: const Text(" Menú principal "),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _ResultRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.overlay,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "$label: $value",
        style: TextStyle(
          fontSize: highlight ? 24 : 18,
          fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          color: highlight ? AppColors.textTitle : AppColors.textPrimary,
        ),
      ),
    );
  }
}
