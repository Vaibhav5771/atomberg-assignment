import 'package:flutter/material.dart';

class AppTextStyles {
  static const String _fontFamily = 'IBMPlexSans';

  // AppBar titles
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  // Section titles / headings
  static const TextStyle heading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Body / normal text
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  // Error text
  static const TextStyle error = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.red,
  );
}
