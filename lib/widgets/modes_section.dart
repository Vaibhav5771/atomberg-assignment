import 'package:flutter/material.dart';

class ModesSection extends StatelessWidget {
  final bool isBoostActive;
  final VoidCallback onBoostOn;
  final VoidCallback onBoostOff;

  const ModesSection({
    super.key,
    required this.isBoostActive,
    required this.onBoostOn,
    required this.onBoostOff,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _BoostCapsule(
          label: 'BOOST',
          isActive: isBoostActive,
          onTap: onBoostOn,
        ),
        _BoostCapsule(
          label: 'NORMAL',
          isActive: !isBoostActive,
          onTap: onBoostOff,
        ),
      ],
    );
  }
}


class _BoostCapsule extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BoostCapsule({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 1.5),
          color: isActive
              ? const Color(0xFF5C6CFF).withOpacity(0.16)
              : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF8FA2FF)
                : Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
