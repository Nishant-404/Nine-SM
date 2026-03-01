import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twentyfour_player/providers/equalizer_provider.dart'; // Ensure this path is correct!

class EqualizerScreen extends ConsumerWidget {
  const EqualizerScreen({super.key});

  final List<String> _bandLabels = const [
    '31', '62', '125', '250', '500', '1k', '2k', '4k', '8k', '16k'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final eqState = ref.watch(eqProvider);
    final eqNotifier = ref.read(eqProvider.notifier);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('9-SM EQ', style: TextStyle(fontWeight: FontWeight.bold)), // <-- Title updated
        actions: [
          Row(
            children: [
              Text(
                eqState.isEqEnabled ? 'ON' : 'BYPASS',
                style: TextStyle(
                  color: eqState.isEqEnabled ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Switch(
                value: eqState.isEqEnabled,
                activeColor: colorScheme.primary,
                onChanged: (val) => eqNotifier.toggleEnabled(val), // Saves to memory instantly
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Opacity(
          opacity: eqState.isEqEnabled ? 1.0 : 0.4,
          child: AbsorbPointer(
            absorbing: !eqState.isEqEnabled,
            child: Column(
              children: [
                const SizedBox(height: 24),

                // ─── Bass & Treble Macro Controls ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMacroControl(
                          title: 'Sub Bass',
                          icon: Icons.speaker,
                          value: eqState.bassLevel,
                          colorScheme: colorScheme,
                          onChanged: (val) => eqNotifier.setBass(val),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildMacroControl(
                          title: 'Treble',
                          icon: Icons.waves,
                          value: eqState.trebleLevel,
                          colorScheme: colorScheme,
                          onChanged: (val) => eqNotifier.setTreble(val),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // ─── Presets & Reset ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // Simple bottom sheet to pick a preset
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                ...EqNotifier.allPresets.map((preset) => ListTile(
                                  title: Text(preset.name),
                                  onTap: () {
                                    eqNotifier.applyPreset(preset);
                                    Navigator.pop(context);
                                  },
                                )),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.queue_music),
                        label: Text(eqState.activePresetName ?? 'Custom'),
                        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
                      ),
                      TextButton.icon(
                        onPressed: () => eqNotifier.reset(),
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset'),
                        style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Divider(indent: 32, endIndent: 32),
                const SizedBox(height: 24),

                // ─── 10-Band Graphic EQ ───
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(10, (index) {
                          return _buildVerticalBand(
                            label: _bandLabels[index],
                            value: eqState.bandLevels[index],
                            colorScheme: colorScheme,
                            onChanged: (val) => eqNotifier.setBand(index, val),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroControl({
    required String title,
    required IconData icon,
    required double value,
    required ColorScheme colorScheme,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.surface,
            ),
            child: Slider(
              value: value,
              min: -1.0,
              max: 1.0,
              onChanged: onChanged,
            ),
          ),
          Text(
            value > 0 ? '+${(value * 10).toStringAsFixed(1)} dB' : '${(value * 10).toStringAsFixed(1)} dB',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBand({
    required String label,
    required double value,
    required ColorScheme colorScheme,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            value > 0 ? '+${(value * 15).toStringAsFixed(1)}' : '${(value * 15).toStringAsFixed(1)}',
            style: TextStyle(fontSize: 11, color: colorScheme.primary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 40,
                  thumbShape: SliderComponentShape.noThumb,
                  activeTrackColor: colorScheme.primary.withOpacity(0.8),
                  inactiveTrackColor: colorScheme.surfaceContainerHighest,
                  trackShape: const RoundedRectSliderTrackShape(),
                ),
                child: Slider(
                  value: value,
                  min: -1.0,
                  max: 1.0,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
          ),
          const Text('Hz', style: TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }
}