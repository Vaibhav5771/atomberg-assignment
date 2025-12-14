import 'package:flutter/material.dart';
import 'credential_text_field.dart';

class LabeledCredentialField extends StatelessWidget {
  final String label;
  final CredentialTextField field;

  const LabeledCredentialField({
    super.key,
    required this.label,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'IBMPlexSans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }
}
