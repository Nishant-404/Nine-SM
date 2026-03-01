import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SleepTimerState {
  final bool isActive;
  final int minutesSet;
  SleepTimerState({this.isActive = false, this.minutesSet = 0});
}

class SleepTimerNotifier extends Notifier<SleepTimerState> {
  Timer? _mainTimer;
  Timer? _fadeTimer;

  @override
  SleepTimerState build() => SleepTimerState();

  // We now require callbacks for pausing AND changing the volume
  void startTimer(int minutes, {
    required VoidCallback onPause,
    required Function(double) onSetVolume
  }) {
    cancelTimer();
    state = SleepTimerState(isActive: true, minutesSet: minutes);

    final totalDuration = Duration(minutes: minutes);
    final fadeStartDelay = totalDuration - const Duration(seconds: 30);

    // If the timer is set for less than 30 seconds (like for testing), just fade immediately
    final delay = fadeStartDelay.isNegative ? Duration.zero : fadeStartDelay;

    _mainTimer = Timer(delay, () {
      _startFadeOut(onPause, onSetVolume);
    });
  }

  void _startFadeOut(VoidCallback onPause, Function(double) onSetVolume) {
    double currentVolume = 1.0;

    // Drop the volume slightly every 3 seconds for 30 seconds
    _fadeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      currentVolume -= 0.1;

      if (currentVolume <= 0.05) {
        timer.cancel();
        onPause(); // Stop the music
        onSetVolume(1.0); // Reset volume to 100% instantly while paused
        cancelTimer(); // Turn off the timer UI
      } else {
        onSetVolume(currentVolume); // Gently lower the volume
      }
    });
  }

  void cancelTimer() {
    _mainTimer?.cancel();
    _fadeTimer?.cancel();
    state = SleepTimerState(isActive: false, minutesSet: 0);
  }
}

final sleepTimerProvider = NotifierProvider<SleepTimerNotifier, SleepTimerState>(() {
  return SleepTimerNotifier();
});