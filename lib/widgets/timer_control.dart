import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TimerControl extends StatelessWidget {
  final int timer; // 0–4
  final String Function(int) labelBuilder;
  final ValueChanged<int> onTimerChanged;

  const TimerControl({
    super.key,
    required this.timer,
    required this.labelBuilder,
    required this.onTimerChanged,
  });

  static const int maxTimer = 4;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapUp: (details) {
          final box = context.findRenderObject() as RenderBox;
          final localY = box.globalToLocal(details.globalPosition).dy;
          final height = box.size.height;

          if (localY < height / 2 && timer < maxTimer) {
            onTimerChanged(timer + 1);
          } else if (localY >= height / 2 && timer > 0) {
            onTimerChanged(timer - 1);
          }
        },
        child: _TimerCapsule(
          level: timer,
          maxLevel: maxTimer,
        ),
      ),
    );
  }
}

class _TimerCapsule extends StatelessWidget {
  final int level;
  final int maxLevel;

  const _TimerCapsule({
    required this.level,
    required this.maxLevel,
  });

  @override
  Widget build(BuildContext context) {
    final double fillPercent =
    (level / maxLevel).clamp(0.0, 1.0);

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
          // Orange fill
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: fillPercent,
                widthFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
              ),
            ),
          ),

          // Center icon
          SvgPicture.asset(
            'assets/icons/timer.svg',
            width: 30,
            height: 30,
            colorFilter: const ColorFilter.mode(
              Colors.orange,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
