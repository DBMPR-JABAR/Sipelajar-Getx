import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: appColor,
  visualDensity: VisualDensity.comfortable,
);

MaterialColor appColor = const MaterialColor(0xFF161E29, {
  50: Color(0xFF3C5D6E),
  100: Color(0xFF2A414F),
  200: Color(0xFF1F2A3C),
  300: Color(0xFF1A2330),
  400: Color(0xFF15202B),
  500: Color(0xFF161E29),
  600: Color(0xFF0F1A24),
  700: Color(0xFF0A1318),
  800: Color(0xFF05090F),
  900: Color(0xFF020305),
});
