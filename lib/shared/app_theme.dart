import 'package:flutter/material.dart';

const _letterSpacing = -0.24;

/// This class holds all theme related data like colors, textStyles and so on.
class AppTheme {
  static const horizontalPadding = 30.0;

  static const topViewSpace = SizedBox(height: 30);

  static final boxShadow = [
    BoxShadow(
      offset: const Offset(0, 1),
      color: Colors.black.withOpacity(0.25),
      blurRadius: 4,
    ),
  ];

  static final theme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
  );

  static const colorIcon = Color(0xFF555555);
  static const colorLightFont = Color(0xFFF5F5F5);
  static const colorUnselected = Color(0xFFBEBDBD);
  static const colorSelected = Color(0xFF555555);
  static const colorOnSelected = Colors.white;

  static const _fontSizeSubtitle1 = 16.0;
  static const textStyleSubtitle1 = TextStyle(
    fontSize: _fontSizeSubtitle1,
    letterSpacing: _letterSpacing,
    height: 20 / _fontSizeSubtitle1,
  );

  static const _fontSizeBody1 = 24.0;
  static const textStyleBody1 = TextStyle(
    fontSize: _fontSizeBody1,
    height: 20 / _fontSizeBody1,
    letterSpacing: _letterSpacing,
  );

  static const _fontSizeBody2 = 20.0;
  static const textStyleBody2 = TextStyle(
    fontSize: _fontSizeBody2,
    letterSpacing: _letterSpacing,
    height: 20 / _fontSizeBody2,
  );

  static const _fontSizeHeadline1 = 96.0;
  static const textStyleHeadline1 = TextStyle(
    fontSize: _fontSizeHeadline1,
    letterSpacing: _letterSpacing,
    height: 113 / _fontSizeHeadline1,
  );

  static const _fontSizeHeadline2 = 96.0;
  static const textStyleHeadline2 = TextStyle(
    fontSize: _fontSizeHeadline2,
    letterSpacing: _letterSpacing,
    fontWeight: FontWeight.w300,
    height: 113 / _fontSizeHeadline2,
  );

  static const _fontSizeHeadline3 = 24.0;
  static const textStyleHeadline3 = TextStyle(
    fontSize: _fontSizeHeadline3,
    fontWeight: FontWeight.w500,
    letterSpacing: _letterSpacing,
    height: _fontSizeHeadline3 / 20,
  );

  static const _fontSizeHeadline4 = 20.0;
  static const textStyleHeadline4 = TextStyle(
    fontSize: _fontSizeHeadline4,
    fontWeight: FontWeight.w500,
    letterSpacing: _letterSpacing,
    height: 20 / _fontSizeHeadline4,
  );
}
