import 'package:equatable/equatable.dart';

enum ClaveMusical {
  solSegunda,  // Clave de Sol en 2ª línea
  faCuarta,    // Clave de Fa en 4ª línea
  faTercera,   // Clave de Fa en 3ª línea
  doPrimera,   // Clave de Do en 1ª línea
  doSegunda,   // Clave de Do en 2ª línea
  doTercera,   // Clave de Do en 3ª línea
  doCuarta,    // Clave de Do en 4ª línea
}

extension ClaveMusicalExtension on ClaveMusical {
  String get label {
    switch (this) {
      case ClaveMusical.solSegunda: return 'Sol\n2ª línea';
      case ClaveMusical.faCuarta:   return 'Fa\n4ª línea';
      case ClaveMusical.faTercera:  return 'Fa\n3ª línea';
      case ClaveMusical.doPrimera:  return 'Do\n1ª línea';
      case ClaveMusical.doSegunda:  return 'Do\n2ª línea';
      case ClaveMusical.doTercera:  return 'Do\n3ª línea';
      case ClaveMusical.doCuarta:   return 'Do\n4ª línea';
    }
  }

  String get unicode {
    switch (this) {
      case ClaveMusical.solSegunda: return '\u{1D11E}'; // sol
      case ClaveMusical.faCuarta:
      case ClaveMusical.faTercera:  return '\u{1D122}'; // fa
      case ClaveMusical.doPrimera:
      case ClaveMusical.doSegunda:
      case ClaveMusical.doTercera:
      case ClaveMusical.doCuarta:   return '\u{1D121}'; // Do
    }
  }
}

class GameSettings extends Equatable {
  final double speed; // 1.0 is normal, <1.0 slower, >1.0 faster
  final bool alternativeGraphics; // True for alternative graphics
  final ClaveMusical clave;

  // Rango del slider de velocidad en Configuración (una sola fuente de verdad).
  static const double minSpeed = 0.5;
  static const double maxSpeed = 2.0;

  const GameSettings({
    required this.speed,
    required this.alternativeGraphics,
    this.clave = ClaveMusical.solSegunda,
  });

  factory GameSettings.defaultSettings() {
    return const GameSettings(speed: 1.0, alternativeGraphics: false, clave: ClaveMusical.solSegunda);
  }

  GameSettings copyWith({double? speed, bool? alternativeGraphics, ClaveMusical? clave}) {
    return GameSettings(
      speed: speed ?? this.speed,
      alternativeGraphics: alternativeGraphics ?? this.alternativeGraphics,
      clave: clave ?? this.clave
    );
  }

  @override
  List<Object> get props => [speed, alternativeGraphics];
}
