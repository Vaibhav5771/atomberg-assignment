import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CredentialTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String svgIconPath; // 👈 SVG instead of IconData
  final String? Function(String?) validator;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;

  const CredentialTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.svgIconPath,
    required this.validator,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
  });

  static const InputDecoration _baseDecoration = InputDecoration(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white30),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    hintStyle: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white54,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: const Color(0xFFFFF200),
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'IBMPlexSans',
      ),
      decoration: _baseDecoration.copyWith(
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            svgIconPath,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
    );
  }
}
