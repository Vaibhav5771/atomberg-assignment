import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SpeedControl extends StatelessWidget {
  final bool isOn;
  final int speed; // 0–5
  final ValueChanged<int> onSpeedChanged;

  const SpeedControl({
    super.key,
    required this.isOn,
    required this.speed,
    required this.onSpeedChanged,
  });

  static const int maxSpeed = 5;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapUp: (details) {
          if (!isOn) return;

          final box = context.findRenderObject() as RenderBox;
          final localY = box.globalToLocal(details.globalPosition).dy;
          final height = box.size.height;

          if (localY < height / 2 && speed < maxSpeed) {
            onSpeedChanged(speed + 1);
          } else if (localY >= height / 2 && speed > 0) {
            onSpeedChanged(speed - 1);
          }
        },
        child: _SpeedCapsule(
          level: speed,
          maxLevel: maxSpeed,
          enabled: isOn,
        ),
      ),
    );
  }
}

class _SpeedCapsule extends StatelessWidget {
  final int level;
  final int maxLevel;
  final bool enabled;

  const _SpeedCapsule({
    required this.level,
    required this.maxLevel,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final double fillPercent =
    enabled ? (level / maxLevel).clamp(0.0, 1.0) : 0;

    return Container(
      width: 75,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blue fill
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: fillPercent,
                widthFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
              ),
            ),
          ),

          // Center icon
          SvgPicture.asset(
            'assets/icons/fan.svg',
            width: 35,
            height: 35,
            colorFilter: const ColorFilter.mode(
              Colors.blue,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
