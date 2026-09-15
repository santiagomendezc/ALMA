import 'package:aplicacion/assets/colores/tema.dart';
import 'package:aplicacion/features/game/domain/entities/note.dart';
import 'package:aplicacion/features/game/presentation/pages/game_over_view.dart';
import 'package:aplicacion/features/game/presentation/providers/game_provider.dart';
import 'package:aplicacion/features/home/home_usuarios_implement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GAME SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Guarda el último nivel visto para saber cuándo mostrar el aviso de
  // "subiste de nivel" (solo una vez por cambio, no en cada rebuild).
  int _lastLevelShown = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startNewGame();
    });
  }

  void _startNewGame() {
    _lastLevelShown = 1;
    context.read<GameProvider>().startGame();
  }

  void _maybeShowLevelUp(GameProvider provider) {
    if (provider.level == _lastLevelShown) return;
    final newLevel = provider.level;
    _lastLevelShown = newLevel;
    final label =
        newLevel >= GameProvider.maxLevel ? '¡Último nivel!' : 'Nivel $newLevel';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('$label · ¡Sube la velocidad!'),
            duration: const Duration(seconds: 2),
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) context.read<GameProvider>().stopGame();
      },
      child: Consumer<GameProvider>(
        builder: (_, provider, __) {
          if (provider.isGameOver) {
            return GameOverView(
              correctCount: provider.correctCount,
              errorCount: provider.errorCount,
              score: provider.score,
              completed: provider.completedAllLevels,
              onRetry: _startNewGame,
              onGoToMenu: () =>
                  Navigator.pushReplacementNamed(context, '/menu_principal'),
            );
          }
          _maybeShowLevelUp(provider);
          return _buildGame(context);
        },
      ),
    );
  }

  Widget _buildGame(BuildContext context) {
    return Fondopantalla(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Consumer<GameProvider>(
            builder: (_, p, __) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Puntaje: ${p.score}'),
                const SizedBox(width: 12),
                Text('Nivel ${p.level}'),
                const SizedBox(width: 12),
                Text('❤ ${p.livesRemaining}'),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [HomeButton()],
        ),
        body: Column(
          children: [
            // ── STAFF (PENTAGRAMA) ─────────────────────────────────────
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.staffBackground,
                  borderRadius: BorderRadius.circular(kPanelRadius),
                ),
                clipBehavior: Clip.hardEdge,
                // LayoutBuilder aquí para obtener dimensiones reales
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: StaffPainter()),
                        ),

                        // ── CLAVE (se actualiza según configuración) ────
                        Consumer<GameProvider>(
                          builder: (_, provider, __) => Positioned(
                            left: 5,
                            top: provider.clefTopOffset,
                            bottom: -7,
                            child: Center(
                              child: Text(
                                provider.claveUnicode, // ← getter del provider
                                style: const TextStyle(
                                  fontFamily: 'Bravura',
                                  fontSize: 120,
                                  color: AppColors.staffInkStrong,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Consumer<GameProvider>(
                          builder: (_, provider, __) {
                            return Stack(
                              children: provider.notesBuffer
                                  .map((note) => AnimatedNoteWidget(
                                        key: ValueKey(note.id),
                                        note: note,
                                        speedMultiplier: provider.speedMultiplier,
                                        onExited: () => provider.removeNote(note),
                                        containerWidth: constraints.maxWidth,
                                        containerHeight: constraints.maxHeight,
                                        clave: provider.currentClave,
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ── ANSWER BUTTONS ─────────────────────────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 5, 14, 14),
                child: Consumer<GameProvider>(
                  builder: (_, gameProvider, __) {
                    return GridView.count(
                      crossAxisCount: 7,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.5,
                      children: gameProvider.availableLetters.map((letter) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.answerButtonBackground,
                            foregroundColor: AppColors.answerButtonForeground,
                            // La forma (píldora) se hereda de elevatedButtonTheme
                          ),
                          onPressed: () {
                            final gp = context.read<GameProvider>();
                            final correct = gp.checkAnswer(letter);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                      correct ? '¡Correcto! +10' : 'Incorrecto -5'),
                                  duration: const Duration(milliseconds: 600),
                                  backgroundColor:
                                      correct ? AppColors.success : AppColors.danger,
                                ),
                              );
                          },
                          child: Text(
                            spanishNameForLetter(letter),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
