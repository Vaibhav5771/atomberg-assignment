import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 225, // 👈 set max width here
        ),
        child: GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
            height: 60,
            width: double.infinity, // fills up to maxWidth
            padding: const EdgeInsets.symmetric(
              horizontal: 60,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF200),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
                : Text(
              text,
              style: const TextStyle(
                fontFamily: 'IBMPlexSans',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
