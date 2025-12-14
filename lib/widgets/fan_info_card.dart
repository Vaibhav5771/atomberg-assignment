import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';

class FanInfoCard extends StatelessWidget {
  final Map<String, dynamic> fan;
  final bool isOnline;

  const FanInfoCard({
    super.key,
    required this.fan,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fan['name'] ?? 'Fan',
                style: AppTextStyles.heading,
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (fan['room'] != null)
            Text(fan['room'], style: AppTextStyles.body),

          const SizedBox(height: 6),

          Text(
            '${fan['model']} • ${fan['series']}',
            style: AppTextStyles.body.copyWith(fontSize: 12),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: Colors.white24),
          ),

          if (!isOnline)
            Text(
              'Device currently offline',
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
        ],
      ),
    );
  }
}
