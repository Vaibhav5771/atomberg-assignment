import 'package:flutter/material.dart';

class SpeedControl extends StatelessWidget {
  final bool isOn;
  final int speed;
  final ValueChanged<int> onSpeedChanged;

  const SpeedControl({
    super.key,
    required this.isOn,
    required this.speed,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Speed Control',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Slider(
          min: 0,
          max: 5,
          divisions: 5,
          value: isOn ? speed.clamp(0, 5).toDouble() : 0,
          label: isOn ? speed.toString() : 'OFF',
          onChanged: isOn
              ? (value) => onSpeedChanged(value.round())
              : null,
        ),
      ],
    );
  }
}
