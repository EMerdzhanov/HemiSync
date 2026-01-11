import 'package:flutter_soloud/flutter_soloud.dart';

enum WaveformType {
  sine('Sine', 'Pure tone'),
  square('Square', 'Rich harmonics'),
  triangle('Triangle', 'Soft harmonics'),
  sawtooth('Sawtooth', 'Bright tone');

  const WaveformType(this.displayName, this.description);

  final String displayName;
  final String description;

  WaveForm toSoLoudWaveForm() {
    switch (this) {
      case WaveformType.sine:
        return WaveForm.sin;
      case WaveformType.square:
        return WaveForm.square;
      case WaveformType.triangle:
        return WaveForm.triangle;
      case WaveformType.sawtooth:
        return WaveForm.saw;
    }
  }
}
