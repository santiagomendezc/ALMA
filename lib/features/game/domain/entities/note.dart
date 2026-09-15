import 'package:aplicacion/features/configuracion/domain/entities/game_settings.dart';
import 'package:uuid/uuid.dart';

enum NotePosition {
  // Octava 1
  C1, D1, E1, F1, G1, A1, B1,
  // Octava 2
  C2, D2, E2, F2, G2, A2, B2,
  // Octava 3
  C3, D3, E3, F3, G3, A3, B3,
  // Octava 4
  C4, D4, E4, F4, G4, A4, B4,
  // Octava 5
  C5, D5, E5, F5, G5, A5, B5,
  // Octava 6
  C6,
}

extension NotePositionExtension on NotePosition {

  // ── LETRA BASE Y NOMBRE EN ESPAÑOL (sin octava) ─────────────────────────
  // Usado para unificar la respuesta: un Do3 y un Do4 se responden igual.
  String get letterName => name.substring(0, 1); // "C4" → "C"

  // ── Nombres de mostrar  ────────────────────────────────────────────────────────────────
  String get label {
    const map = {
      NotePosition.C1: 'Do', NotePosition.D1: 'Re1', NotePosition.E1: 'Mi1',
      NotePosition.F1: 'Fa1', NotePosition.G1: 'Sol1',NotePosition.A1: 'La1',
      NotePosition.B1: 'Si1',
      NotePosition.C2: 'Do', NotePosition.D2: 'Re2', NotePosition.E2: 'Mi2',
      NotePosition.F2: 'Fa2', NotePosition.G2: 'Sol2',NotePosition.A2: 'La2',
      NotePosition.B2: 'Si2',
      NotePosition.C3: 'Do', NotePosition.D3: 'Re3', NotePosition.E3: 'Mi3',
      NotePosition.F3: 'Fa3', NotePosition.G3: 'Sol3',NotePosition.A3: 'La3',
      NotePosition.B3: 'Si3',
      NotePosition.C4: 'Do', NotePosition.D4: 'Re4', NotePosition.E4: 'Mi4',
      NotePosition.F4: 'Fa4', NotePosition.G4: 'Sol4',NotePosition.A4: 'La4',
      NotePosition.B4: 'Si4',
      NotePosition.C5: 'Do', NotePosition.D5: 'Re5', NotePosition.E5: 'Mi5',
      NotePosition.F5: 'Fa5', NotePosition.G5: 'Sol5',NotePosition.A5: 'La5',
      NotePosition.B5: 'Si5',
      NotePosition.C6: 'Do',
    };
    return map[this]!;
  }

  // ── STAFF STEP POR CLAVE ─────────────────────────────────────────────────
  int staffStepForClave(ClaveMusical clave) {
    switch (clave) {
      case ClaveMusical.solSegunda: return _staffStepSolSegunda;
      case ClaveMusical.faCuarta:   return _staffStepFaCuarta;
      case ClaveMusical.faTercera:  return _staffStepFaTercera;
      case ClaveMusical.doPrimera:  return _staffStepDoPrimera;
      case ClaveMusical.doSegunda:  return _staffStepDoSegunda;
      case ClaveMusical.doTercera:  return _staffStepDoTercera;
      case ClaveMusical.doCuarta:   return _staffStepDoCuarta;
    }
  }

  int get _staffStepSolSegunda {
    const map = {
      NotePosition.C4:  6, NotePosition.D4:  5, NotePosition.E4:  4,
      NotePosition.F4:  3, NotePosition.G4:  2, NotePosition.A4:  1,
      NotePosition.B4:  0,
      NotePosition.C5: -1, NotePosition.D5: -2, NotePosition.E5: -3,
      NotePosition.F5: -4, NotePosition.G5: -5, NotePosition.A5: -6,
      NotePosition.B5: -7,
    };
    return map[this] ?? 0;
  }

  int get _staffStepFaCuarta {
    const map = {
      NotePosition.E2:  6, NotePosition.F2:  5, NotePosition.G2:  4,
      NotePosition.A2:  3, NotePosition.B2:  2, NotePosition.C2:  1,
      NotePosition.D3:  0,
      NotePosition.E3: -1, NotePosition.F3: -2, NotePosition.G3: -3,
      NotePosition.A3: -4, NotePosition.B3: -5, NotePosition.C4: -6,
      NotePosition.D4: -7,
    };
    return map[this] ?? 0;
  }

  int get _staffStepFaTercera {
    const map = {
      NotePosition.A2:  8, NotePosition.B2:  7,
      NotePosition.C3:  6, NotePosition.D3:  5, NotePosition.E3:  4,
      NotePosition.F3:  3, NotePosition.G3:  2, NotePosition.A3:  1,
      NotePosition.B3:  0,
      NotePosition.C4: -1, NotePosition.D4: -2, NotePosition.E4: -3,
      NotePosition.F4: -4, NotePosition.G4: -5,
    };
    return map[this] ?? 0;
  }

  int get _staffStepDoPrimera {
    const map = {
      NotePosition.D3:  8, NotePosition.E3:  7,
      NotePosition.F3:  6, NotePosition.G3:  5, NotePosition.A3:  4,
      NotePosition.B3:  3,
      NotePosition.C4:  2, NotePosition.D4:  1, NotePosition.E4:  0,
      NotePosition.F4: -1, NotePosition.G4: -2, NotePosition.A4: -3,
      NotePosition.B4: -4,
      NotePosition.C5: -5,
    };
    return map[this] ?? 0;
  }

  int get _staffStepDoSegunda {
    const map = {
      NotePosition.E3:  8,
      NotePosition.F3:  7, NotePosition.G3:  6, NotePosition.A3:  5,
      NotePosition.B3:  4,
      NotePosition.C4:  3, NotePosition.D4:  2, NotePosition.E4:  1,
      NotePosition.F4:  0, NotePosition.G4: -1, NotePosition.A4: -2,
      NotePosition.B4: -3,
      NotePosition.C5: -4, NotePosition.D5: -5,
    };
    return map[this] ?? 0;
  }

  int get _staffStepDoTercera {
    const map = {
      NotePosition.F3:  8, NotePosition.G3:  7, NotePosition.A3:  6,
      NotePosition.B3:  5,
      NotePosition.C4:  4, NotePosition.D4:  3, NotePosition.E4:  2,
      NotePosition.F4:  1, NotePosition.G4:  0, NotePosition.A4: -1,
      NotePosition.B4: -2,
      NotePosition.C5: -3, NotePosition.D5: -4, NotePosition.E5: -5,
    };
    return map[this] ?? 0;
  }

  int get _staffStepDoCuarta {
    const map = {
      NotePosition.G3:  8, NotePosition.A3:  7, NotePosition.B3:  6,
      NotePosition.C4:  5, NotePosition.D4:  4, NotePosition.E4:  3,
      NotePosition.F4:  2, NotePosition.G4:  1, NotePosition.A4:  0,
      NotePosition.B4: -1,
      NotePosition.C5: -2, NotePosition.D5: -3, NotePosition.E5: -4,
      NotePosition.F5: -5,
    };
    return map[this] ?? 0;
  }
}


/// Nombre en español (Do, Re, Mi...) para una letra de nota ('C','D','E'...),
/// sin importar la octava. Se usa para los botones de respuesta unificados.
String spanishNameForLetter(String letter) {
  const map = {
    'C': 'Do', 'D': 'Re', 'E': 'Mi', 'F': 'Fa',
    'G': 'Sol', 'A': 'La', 'B': 'Si',
  };
  return map[letter] ?? letter;
}

List<NotePosition> notesForClave(ClaveMusical clave) {
  switch (clave) {
    case ClaveMusical.solSegunda:
      return [
        NotePosition.C4, NotePosition.D4, NotePosition.E4, NotePosition.F4,
        NotePosition.G4, NotePosition.A4, NotePosition.B4,
        NotePosition.C5, NotePosition.D5, NotePosition.E5, NotePosition.F5,
        NotePosition.G5, NotePosition.A5, NotePosition.B5,
      ];
    case ClaveMusical.faCuarta:
      return [
        NotePosition.E2, NotePosition.F2, NotePosition.G2,
        NotePosition.A2, NotePosition.B2, NotePosition.C3, NotePosition.D3,
        NotePosition.E3, NotePosition.F3, NotePosition.G3,
        NotePosition.A3, NotePosition.B3, NotePosition.C4, NotePosition.D4,
      ];
    case ClaveMusical.faTercera:
      return [
        NotePosition.A2, NotePosition.B2,
        NotePosition.C3, NotePosition.D3, NotePosition.E3, NotePosition.F3,
        NotePosition.G3, NotePosition.A3, NotePosition.B3,
        NotePosition.C4, NotePosition.D4, NotePosition.E4, NotePosition.F4,
        NotePosition.G4,
      ];
    case ClaveMusical.doPrimera:
      return [
        NotePosition.D3, NotePosition.E3, NotePosition.F3, NotePosition.G3,
        NotePosition.A3, NotePosition.B3,
        NotePosition.C4, NotePosition.D4, NotePosition.E4, NotePosition.F4,
        NotePosition.G4, NotePosition.A4, NotePosition.B4,
        NotePosition.C5,
      ];
    case ClaveMusical.doSegunda:
      return [
        NotePosition.E3, NotePosition.F3, NotePosition.G3, NotePosition.A3,
        NotePosition.B3,
        NotePosition.C4, NotePosition.D4, NotePosition.E4, NotePosition.F4,
        NotePosition.G4, NotePosition.A4, NotePosition.B4,
        NotePosition.C5, NotePosition.D5,
      ];
    case ClaveMusical.doTercera:
      return [
        NotePosition.F3, NotePosition.G3, NotePosition.A3, NotePosition.B3,
        NotePosition.C4, NotePosition.D4, NotePosition.E4, NotePosition.F4,
        NotePosition.G4, NotePosition.A4, NotePosition.B4,
        NotePosition.C5, NotePosition.D5, NotePosition.E5,
      ];
    case ClaveMusical.doCuarta:
      return [
        NotePosition.G3, NotePosition.A3, NotePosition.B3,
        NotePosition.C4, NotePosition.D4, NotePosition.E4, NotePosition.F4,
        NotePosition.G4, NotePosition.A4, NotePosition.B4,
        NotePosition.C5, NotePosition.D5, NotePosition.E5, NotePosition.F5,
      ];
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// NOTE
// ─────────────────────────────────────────────────────────────────────────────
class Note {
  final String id;
  final NotePosition position;

  Note({required this.position}) : id = const Uuid().v4();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

