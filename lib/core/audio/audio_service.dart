import 'package:aplicacion/features/game/domain/entities/note.dart';
import 'package:audioplayers/audioplayers.dart';

/// Servicio central de audio de la app.
///
/// Por ahora solo maneja el efecto de sonido que suena al responder una
/// nota en el juego. (Música de fondo pendiente para más adelante.)
class AudioService {
  final AudioPlayer _sfxPlayer = AudioPlayer();

  AudioService() {
    // Modo de baja latencia: ideal para efectos cortos como estos.
    _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  /// Reproduce el sonido correspondiente a la nota seleccionada
  /// (ej. NotePosition.C4 → assets/audio/notas/c4.wav).
  Future<void> playNoteSound(NotePosition note) async {
    try {
      final fileName = note.name.toLowerCase();
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('audio/notas/$fileName.wav'));
    } catch (_) {
      // Si el archivo de audio falta o el dispositivo no puede reproducirlo,
      // la app sigue funcionando en silencio en vez de romperse.
    }
  }

  Future<void> dispose() async {
    await _sfxPlayer.dispose();
  }
}
