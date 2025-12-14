import 'package:flutter/material.dart';

class PowerControls extends StatelessWidget {
  final bool isOn;
  final VoidCallback onOn;
  final VoidCallback onOff;

  const PowerControls({
    super.key,
    required this.isOn,
    required this.onOn,
    required this.onOff,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Power', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: isOn ? null : onOn,
              child: const Text('TURN ON'),
            ),
            ElevatedButton(
              onPressed: !isOn ? null : onOff,
              child: const Text('TURN OFF'),
            ),
          ],
        ),
      ],
    );
  }
}
