import 'dart:async';
import 'dart:math';
import 'package:aplicacion/assets/colores/tema.dart';
import 'package:aplicacion/core/audio/audio_service.dart';
import 'package:aplicacion/features/configuracion/domain/entities/game_settings.dart';
import 'package:aplicacion/features/configuracion/presentation/providers/settings_provider.dart';
import 'package:aplicacion/features/game/domain/entities/note.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  final SettingsProvider settingsProvider;
  final AudioService audioService;

  GameProvider({required this.settingsProvider, required this.audioService});

  // ── CONFIGURACIÓN DEL DESAFÍO ─────────────────────────────────────────
  static const int maxErrors = 3; // vidas: a los 3 errores termina el juego
  static const int streakToLevelUp = 6; // aciertos seguidos para subir de nivel

  // Niveles de VELOCIDAD: se calculan automáticamente para ir del mínimo
  // (GameSettings.minSpeed) al máximo (GameSettings.maxSpeed) en pasos
  // parejos. El nivel de pool de notas (5 → 10 → todas) solo cambia en
  // los primeros 3; del 3 en adelante ya son todas las notas y cada nivel
  // extra solo sigue acelerando hasta llegar exactamente al máximo.
  static const int speedLevelCount = 6; // niveles necesarios hasta el máximo
  static final List<double> _levelSpeeds = List.generate(
    speedLevelCount,
    (i) => GameSettings.minSpeed +
        (GameSettings.maxSpeed - GameSettings.minSpeed) * i / (speedLevelCount - 1),
  );
  static int get maxLevel => speedLevelCount; // el último = velocidad máxima

  final List<Note> _notesBuffer = [];
  List<Note> get notesBuffer => List.unmodifiable(_notesBuffer);

  int _score = 0;
  int get score => _score;

  int _correctCount = 0;
  int get correctCount => _correctCount;

  int _errorCount = 0;
  int get errorCount => _errorCount;
  int get livesRemaining => maxErrors - _errorCount;

  int _streak = 0;
  int get streak => _streak;

  int _level = 1;
  int get level => _level;
  bool get isLastLevel => _level >= maxLevel;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isGameOver = false;
  bool get isGameOver => _isGameOver;

  bool _completedAllLevels = false;
  bool get completedAllLevels => _completedAllLevels;

  Timer? _noteSpawnTimer;

  // Velocidad SIEMPRE arranca en el mínimo configurable (0.5), sin importar
  // lo que el usuario haya dejado guardado en "Velocidad" de Configuración.
  // Desde ahí, el sistema de niveles va acelerando hasta el máximo (2.0).
  double get speedMultiplier => _levelSpeeds[_level - 1];
  ClaveMusical get currentClave => settingsProvider.settings.clave;

  // Todas las notas posibles para la clave configurada, ordenadas por altura.
  // Para las claves de Fa, se recortan a partir del Do central hacia abajo
  // (no tiene sentido mostrar notas por encima del Do central en esa clave).
  List<NotePosition> get _fullNotePool {
    final notes = notesForClave(settingsProvider.settings.clave);
    final clave = settingsProvider.settings.clave;
    if (clave == ClaveMusical.faCuarta || clave == ClaveMusical.faTercera) {
      final centralDoIndex = notes.indexOf(NotePosition.C4);
      if (centralDoIndex != -1) {
        return notes.sublist(0, centralDoIndex + 1); // hasta el Do central
      }
    }
    return notes;
  }

  // Notas de la clave ordenadas por cercanía al Do central (C4): primero C4,
  // luego alternando la nota inmediatamente superior e inferior, etc.
  // Así el nivel 1 empieza siempre "desde el Do central hacia afuera".
  List<NotePosition> get _notesByProximityToMiddleC {
    final notes = _fullNotePool;
    final centerIndex = notes.indexOf(NotePosition.C4);
    if (centerIndex == -1) return notes; // por seguridad, si no está el Do
    final result = <NotePosition>[notes[centerIndex]];
    int lower = centerIndex - 1;
    int upper = centerIndex + 1;
    while (lower >= 0 || upper < notes.length) {
      if (upper < notes.length) {
        result.add(notes[upper]);
        upper++;
      }
      if (lower >= 0) {
        result.add(notes[lower]);
        lower--;
      }
    }
    return result;
  }

  // Notas disponibles para el nivel actual (usadas tanto para las notas que
  // aparecen en el pentagrama como para los botones de respuesta).
  List<NotePosition> get availableNotes {
    final full = _fullNotePool;
    List<NotePosition> selected;
    switch (_level) {
      case 1:
        selected = _notesByProximityToMiddleC.take(5).toList();
        break;
      case 2:
        selected = _notesByProximityToMiddleC.take(10).toList();
        break;
      default:
        selected = full; // nivel 3 y último nivel: todas las notas
    }
    // Se muestran siempre ordenadas de grave a agudo.
    selected.sort((a, b) => full.indexOf(a).compareTo(full.indexOf(b)));
    return selected;
  }

  // Letras únicas (Do, Re, Mi...) presentes en el nivel actual, en orden
  // musical fijo. Un solo botón "Do" sirve para responder cualquier Do,
  // sin importar la octava (C3, C4, etc.).
  static const List<String> _letterOrder = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  List<String> get availableLetters {
    final present = availableNotes.map((n) => n.letterName).toSet();
    return _letterOrder.where(present.contains).toList();
  }

  // ── POSICIÓN VERTICAL DEL SÍMBOLO DE LA CLAVE ────────────────────────
  // El "top" base se calibró visualmente para la clave de Sol; el glifo
  // de Fa (y el de Do) tiene un centro visual distinto dentro de la
  // fuente Bravura, así que aquí se ajusta un poco por tipo de clave.
  //
  // Nota para seguir afinando a ojo: bajar este número sube el símbolo
  // en pantalla, subirlo lo baja. Si mandas otra captura, puedo volver
  // a medir el desfase exacto en píxeles y recalcular.
  double get clefTopOffset {
    switch (settingsProvider.settings.clave) {
      case ClaveMusical.solSegunda:
        return 25;
      case ClaveMusical.faCuarta:
      case ClaveMusical.faTercera:
        return -21; // se sube respecto al valor usado para Sol
      case ClaveMusical.doPrimera:
      case ClaveMusical.doSegunda:
      case ClaveMusical.doTercera:
      case ClaveMusical.doCuarta:
        return 25;
    }
  }

  // ── UNICODE DE LA CLAVE  ──────────────────────────────────────────
  String get claveUnicode {
    switch (settingsProvider.settings.clave) {
      case ClaveMusical.solSegunda: return '\u{1D11E}'; // Sol
      case ClaveMusical.faCuarta:
      case ClaveMusical.faTercera:  return '\u{1D122}'; // Fa
      case ClaveMusical.doPrimera:
      case ClaveMusical.doSegunda:
      case ClaveMusical.doTercera:
      case ClaveMusical.doCuarta:   return '\u{1D121}'; // Do
    }
  }

  void startGame() {
    _score = 0;
    _correctCount = 0;
    _errorCount = 0;
    _streak = 0;
    _level = 1;
    _isGameOver = false;
    _completedAllLevels = false;
    _notesBuffer.clear();
    _isPlaying = true;
    notifyListeners();
    _scheduleNextNote();
  }

  void _scheduleNextNote() {
    if (!_isPlaying) return;
    final intervalMs = (3000 / speedMultiplier).round();
    _noteSpawnTimer = Timer(Duration(milliseconds: intervalMs), () {
      _spawnNote();
      _scheduleNextNote();
    });
  }

  void stopGame() {
    _isPlaying = false;
    _noteSpawnTimer?.cancel();
    _notesBuffer.clear();
    notifyListeners();
  }

  void _spawnNote() {
    if (!_isPlaying) return;
    final notes = availableNotes;
    final notePosition = notes[Random().nextInt(notes.length)];
    _notesBuffer.add(Note(position: notePosition));
    audioService.playNoteSound(notePosition); // suena al aparecer, no al responder
    notifyListeners();
  }

  // Solo se llama desde onExited (nota llega a la clave sin respuesta)
  void removeNote(Note note) {
    if (!_isPlaying) return;
    if (_notesBuffer.contains(note)) {
      _score -= 5;
      _notesBuffer.remove(note);
      _registerError();
      notifyListeners();
    }
  }

  bool checkAnswer(String letter) {
    if (!_isPlaying || _notesBuffer.isEmpty) return false;
    final targetNote = _notesBuffer.first;
    if (targetNote.position.letterName == letter) {
      _score += 10;
      _correctCount++;
      _streak++;
      _notesBuffer.remove(targetNote);
      _checkLevelProgress();
      notifyListeners();
      return true;
    } else {
      _score -= 5;
      _registerError();
      notifyListeners();
      return false;
    }
  }

  // Cada [streakToLevelUp] aciertos consecutivos se avanza de nivel
  // (más notas en juego y más velocidad). Si ya se estaba en el último
  // nivel, 6 aciertos más terminan la partida (completada con éxito).
  void _checkLevelProgress() {
    if (!_isPlaying) return;
    if (_streak > 0 && _streak % streakToLevelUp == 0) {
      _streak = 0; // se exige una racha nueva de 6 para el siguiente paso
      if (_level < maxLevel) {
        _level++;
      } else {
        _endGame(completed: true);
      }
    }
  }

  // Un error (respuesta incorrecta o nota no respondida) corta la racha
  // y consume una "vida". Al llegar a [maxErrors] termina la partida.
  void _registerError() {
    if (!_isPlaying) return;
    _errorCount++;
    _streak = 0;
    if (_errorCount >= maxErrors) {
      _endGame(completed: false);
    }
  }

  void _endGame({required bool completed}) {
    _isPlaying = false;
    _isGameOver = true;
    _completedAllLevels = completed;
    _noteSpawnTimer?.cancel();
    _notesBuffer.clear();
  }

  @override
  void dispose() {
    _noteSpawnTimer?.cancel();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED NOTE WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class AnimatedNoteWidget extends StatefulWidget {
  final Note note;
  final double speedMultiplier;
  final VoidCallback onExited;
  final double containerWidth;
  final double containerHeight;
  final ClaveMusical clave;

  const AnimatedNoteWidget({
    required super.key,
    required this.note,
    required this.speedMultiplier,
    required this.onExited,
    required this.containerWidth,
    required this.containerHeight,
    required this.clave,
  });

  @override
  State<AnimatedNoteWidget> createState() => _AnimatedNoteWidgetState();
}

class _AnimatedNoteWidgetState extends State<AnimatedNoteWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _exited = false; // ← nivel de clase

  static const double _lineSpacing = 20.0;
  static const double _noteWidth   = 40.0;
  static const double _noteHeight  = 50.0;
  static const double _clefWidth   = 80.0;

  @override
  void initState() {
    super.initState();
    final durationMs = (5000 / widget.speedMultiplier).round();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    );
    _controller.addListener(_checkIfReachedClef);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _triggerExit();
    });
    _controller.forward();
  }

  void _checkIfReachedClef() {
    final startX   = widget.containerWidth;
    const endX     = -_noteWidth;
    final currentX = startX + (endX - startX) * _controller.value;
    if (currentX <= _clefWidth) _triggerExit();
  }

  void _triggerExit() {
    if (_exited) return;
    _exited = true;
    _controller.stop();
    widget.onExited();
  }

  @override
  void dispose() {
    _controller.removeListener(_checkIfReachedClef);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final centerY    = widget.containerHeight / 2;
    final topPosition = centerY
        + (widget.note.position.staffStepForClave(widget.clave) * _lineSpacing / 2)
        - _noteHeight / 2;

    final startX = widget.containerWidth;
    const endX   = -_noteWidth;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final leftPos = startX + (endX - startX) * _controller.value;
        return Positioned(
          left: leftPos,
          top: topPosition,
          child: _NoteHead(notePosition: widget.note.position),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NOTE HEAD
// ─────────────────────────────────────────────────────────────────────────────
class _NoteHead extends StatelessWidget {
  final NotePosition notePosition;
  

  const _NoteHead({required this.notePosition});

  static const double _fontSize      = 50.0;
  static const double _lineWidth     = 37.0;
  static const double _lineThickness = 1.0;

  @override
  Widget build(BuildContext context) {
    final double boxHeight = notePosition == NotePosition.C6 ? 70.0 : 50.0;

    return SizedBox(
      width: 40,
      height: boxHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          if (notePosition == NotePosition.C4)
            Positioned(top: 24, left: 2, child: _auxLine()),

          if (notePosition == NotePosition.A5)
            Positioned(top: 24, left: 2, child: _auxLine()),

          if (notePosition == NotePosition.B5)
            Positioned(top: 34, left: 2, child: _auxLine()),

          if (notePosition == NotePosition.C6) ...[
            Positioned(top: 47, left: 2, child: _auxLine()),
            Positioned(top: 34, left: 2, child: _auxLine()),
          ],

          Positioned(
            top: boxHeight / 2 - 25,
            left: 0,
            right: 0,
            child: Text(
              '\u{1D15D}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Bravura',
                fontSize: _fontSize,
                color: AppColors.staffInkStrong,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _auxLine() => Container(
        width: _lineWidth,
        height: _lineThickness,
        color: AppColors.staffInkStrong,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// STAFF PAINTER
// ─────────────────────────────────────────────────────────────────────────────
class StaffPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.staffInk
      ..strokeWidth = 1.5;

    const lineSpacing = 20.0;
    final centerY = size.height / 2;
    for (int i = -2; i <= 2; i++) {
      final y = centerY + i * lineSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
