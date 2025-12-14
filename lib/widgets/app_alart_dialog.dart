import 'package:flutter/material.dart';
import 'app_alert_type.dart';

void showAppAlertDialog({
  required BuildContext context,
  required AppAlertType type,
  required String message,
}) {
  late IconData icon;
  late Color accentColor;

  switch (type) {
    case AppAlertType.error:
      icon = Icons.error_outline;
      accentColor = Colors.redAccent;
      break;

    case AppAlertType.warning:
      icon = Icons.warning_amber_rounded;
      accentColor = Colors.orangeAccent;
      break;

    case AppAlertType.comingSoon:
      icon = Icons.watch_later_outlined;
      accentColor = const Color(0xFFFFF200);
      break;
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(
            color: accentColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 36,
                color: accentColor,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'IBMPlexMono',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
