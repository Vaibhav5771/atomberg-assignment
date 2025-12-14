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
    return Center(
      child: GestureDetector(
        onTap: isOn ? onOff : onOn,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            color: isOn
                ? Colors.green.withOpacity(0.25) // ON background
                : Colors.transparent, // OFF background
          ),
          child: Center(
            child: Icon(
              Icons.power_settings_new,
              size: 36,
              color: isOn ? Colors.green : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
