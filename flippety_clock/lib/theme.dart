import 'package:flutter/material.dart';

enum ThemeElement {
  //color when the digit matrix element should be displayed
  flipped,
  //color when the digit matrix element should be blended in background
  //also the background color of the clock
  notFlipped,
  //the glow effect color of the flipped element
  shadow,
}

final lightTheme = {
  ThemeElement.notFlipped: const Color.fromRGBO(251, 236, 213, 1.0),
  ThemeElement.flipped: const Color.fromRGBO(25, 29, 38, 1.0),
  ThemeElement.shadow: const Color.fromRGBO(25, 29, 38, 1.0),
};

final darkTheme = {
  ThemeElement.notFlipped: const Color.fromRGBO(25, 29, 38, 1.0),
  ThemeElement.flipped: const Color.fromRGBO(251, 236, 213, 1.0),
  ThemeElement.shadow: Colors.white,
};
