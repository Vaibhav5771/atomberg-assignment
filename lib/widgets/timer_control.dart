import 'package:flutter/material.dart';

class TimerControl extends StatelessWidget {
  final int timer;
  final String Function(int) labelBuilder;
  final ValueChanged<int> onTimerChanged;

  const TimerControl({
    super.key,
    required this.timer,
    required this.labelBuilder,
    required this.onTimerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Timer',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Slider(
          min: 0,
          max: 4,
          divisions: 4,
          value: timer.clamp(0, 4).toDouble(),
          label: labelBuilder(timer),
          activeColor: Colors.orange,
          onChanged: (value) => onTimerChanged(value.round()),
        ),
        Center(
          child: Text(
            'Timer: ${labelBuilder(timer)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
