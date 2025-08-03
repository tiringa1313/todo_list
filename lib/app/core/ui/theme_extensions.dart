import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorLight => Theme.of(this).primaryColorLight;
  Color get buttonColor => Theme.of(this).colorScheme.primary;

  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle get titleStyle =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey);
}
