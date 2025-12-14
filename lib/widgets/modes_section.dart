import 'package:flutter/material.dart';

class ModesSection extends StatelessWidget {
  final VoidCallback onBoostOn;
  final VoidCallback onBoostOff;

  const ModesSection({
    super.key,
    required this.onBoostOn,
    required this.onBoostOff,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Modes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: onBoostOn,
              icon: const Icon(Icons.speed),
              label: const Text('Boost ON'),
            ),
            OutlinedButton.icon(
              onPressed: onBoostOff,
              icon: const Icon(Icons.speed_outlined),
              label: const Text('Boost OFF'),
            ),
          ],
        ),
      ],
    );
  }
}
