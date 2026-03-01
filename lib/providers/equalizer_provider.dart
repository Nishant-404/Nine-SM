import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twentyfour_player/providers/playback_provider.dart'; // <-- Correct import location!

class EqPreset {
  final String name;
  final double bassLevel;
  final double trebleLevel;
  final List<double> bandLevels;

  const EqPreset({
    required this.name,
    this.bassLevel = 0.0,
    this.trebleLevel = 0.0,
    required this.bandLevels,
  });
}

class EqState {
  final bool isEqEnabled;
  final double bassLevel;
  final double trebleLevel;
  final List<double> bandLevels;
  final String? activePresetName;

  EqState({
    this.isEqEnabled = false,
    this.bassLevel = 0.0,
    this.trebleLevel = 0.0,
    List<double>? bandLevels,
    this.activePresetName,
  }) : bandLevels = bandLevels ?? List.filled(10, 0.0);

  EqState copyWith({
    bool? isEqEnabled,
    double? bassLevel,
    double? trebleLevel,
    List<double>? bandLevels,
    String? activePresetName,
  }) {
    return EqState(
      isEqEnabled: isEqEnabled ?? this.isEqEnabled,
      bassLevel: bassLevel ?? this.bassLevel,
      trebleLevel: trebleLevel ?? this.trebleLevel,
      bandLevels: bandLevels ?? this.bandLevels,
      activePresetName: activePresetName ?? this.activePresetName,
    );
  }
}

class EqNotifier extends Notifier<EqState> {
  // ─── Standard & Bass Presets ───
  // ─── Standard & Bass Presets ───
  static const presetFlat = EqPreset(name: 'Flat', bandLevels: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);
  static const presetBassTreble = EqPreset(name: 'Bass & Treble', bandLevels: [0.387, 0.387, 0.2, 0.0, -0.1, -0.1, 0.0, 0.0, 0.0, 0.0]);
  static const presetOnlyBass = EqPreset(name: 'Only Bass', bandLevels: [0.387, 0.387, 0.2, 0.0, -0.1, -0.1, 0.0, 0.0, 0.0, 0.0]);
  static const presetBassExtreme = EqPreset(name: 'Bass Extreme', bandLevels: [0.4, 0.4, 0.333, 0.0, -0.1, -0.1, 0.0, 0.0, 0.0, 0.0]);
  static const presetPop = EqPreset(name: 'Pop', bandLevels: [0.1, 0.3, 0.387, 0.2, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0]);

  // ─── Audiophile IEM Targets ───
  static const presetBlon07 = EqPreset(name: 'BLON BL-07', bandLevels: [-0.16, -0.18, -0.327, -0.26, 0.04, 0.273, 0.253, 0.0, 0.0, 0.0]);
  static const presetTruthearBlue = EqPreset(name: 'Truthear Zero (Blue)', bandLevels: [0.007, 0.093, 0.187, 0.38, 0.287, 0.267, 0.32, 0.0, 0.0, 0.0]);
  static const presetTruthearRed = EqPreset(name: 'Truthear Zero (Red)', bandLevels: [-0.14, -0.107, -0.04, -0.027, -0.013, 0.06, 0.12, 0.0, 0.0, 0.0]);
  static const presetSimgotEw300 = EqPreset(name: 'Simgot EW300', bandLevels: [0.113, 0.16, 0.107, 0.12, 0.267, 0.287, 0.22, 0.0, 0.0, 0.0]);
  // The master list that powers the UI dropdown
  static const List<EqPreset> allPresets = [
    presetFlat,
    presetBassTreble,
    presetOnlyBass,
    presetBassExtreme,
    presetPop,
    presetBlon07,
    presetTruthearBlue,
    presetTruthearRed,
    presetSimgotEw300,
  ];

  @override
  EqState build() => EqState();

  void toggleEnabled(bool enabled) {
    state = state.copyWith(isEqEnabled: enabled);
    ref.read(playbackProvider.notifier).setEqEnabled(enabled);
  }

  void setBass(double level) {
    state = state.copyWith(bassLevel: level, activePresetName: 'Custom');
    ref.read(playbackProvider.notifier).setBassHardware(level);
  }

  void setTreble(double level) {
    state = state.copyWith(trebleLevel: level, activePresetName: 'Custom');
    ref.read(playbackProvider.notifier).setTrebleHardware(level);
  }

  void setBand(int index, double level) {
    final newBands = List<double>.from(state.bandLevels);
    newBands[index] = level;
    state = state.copyWith(bandLevels: newBands, activePresetName: 'Custom');
    ref.read(playbackProvider.notifier).setEqBandHardware(index, level);
  }

  void applyPreset(EqPreset preset) {
    state = state.copyWith(
      bassLevel: preset.bassLevel,
      trebleLevel: preset.trebleLevel,
      bandLevels: preset.bandLevels,
      activePresetName: preset.name,
    );
    ref.read(playbackProvider.notifier).setBassHardware(preset.bassLevel);
    ref.read(playbackProvider.notifier).setTrebleHardware(preset.trebleLevel);
    for (int i = 0; i < preset.bandLevels.length; i++) {
      ref.read(playbackProvider.notifier).setEqBandHardware(i, preset.bandLevels[i]);
    }
  }

  void reset() {
    applyPreset(presetFlat);
  }
}

final eqProvider = NotifierProvider<EqNotifier, EqState>(() => EqNotifier());