class AudioConstants {
  AudioConstants._();

  static const double minFrequency = 1.0;
  static const double maxFrequency = 25000.0;
  static const double defaultFrequency = 200.0;
  static const double defaultVolume = 0.8;

  static const double deltaMin = 0.5;
  static const double deltaMax = 4.0;
  static const double thetaMin = 4.0;
  static const double thetaMax = 8.0;
  static const double alphaMin = 8.0;
  static const double alphaMax = 14.0;
  static const double betaMin = 14.0;
  static const double betaMax = 30.0;
  static const double gammaMin = 30.0;
  static const double gammaMax = 100.0;
}

enum BrainwaveCategory {
  delta('Delta', 'Deep sleep, healing'),
  theta('Theta', 'Meditation, creativity'),
  alpha('Alpha', 'Relaxation, calm focus'),
  beta('Beta', 'Focus, concentration'),
  gamma('Gamma', 'Peak awareness, insight'),
  none('None', 'Outside brainwave range');

  const BrainwaveCategory(this.name, this.description);

  final String name;
  final String description;

  static BrainwaveCategory fromFrequency(double frequency) {
    if (frequency >= AudioConstants.deltaMin &&
        frequency < AudioConstants.thetaMin) {
      return BrainwaveCategory.delta;
    } else if (frequency >= AudioConstants.thetaMin &&
        frequency < AudioConstants.alphaMin) {
      return BrainwaveCategory.theta;
    } else if (frequency >= AudioConstants.alphaMin &&
        frequency < AudioConstants.betaMin) {
      return BrainwaveCategory.alpha;
    } else if (frequency >= AudioConstants.betaMin &&
        frequency < AudioConstants.gammaMin) {
      return BrainwaveCategory.beta;
    } else if (frequency >= AudioConstants.gammaMin &&
        frequency <= AudioConstants.gammaMax) {
      return BrainwaveCategory.gamma;
    }
    return BrainwaveCategory.none;
  }
}
