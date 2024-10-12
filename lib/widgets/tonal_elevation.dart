import 'package:flutter/material.dart';

enum Elevation {level0, level1, level2, level3, level4 ,level5}

Color _tonalElevation({
  required Color color,
  required Elevation level,
  required BuildContext context,
}){
  double strength = switch (level) {
    Elevation.level0 => 0,
    Elevation.level1 => 0.01,
    Elevation.level2 => 0.02,
    Elevation.level3 => 0.06,
    Elevation.level4 => 0.08,
    Elevation.level5 => 0.12
  };
  int r = color.red;
  int g = color.green;
  int b = color.blue;

  return MediaQuery.of(context).platformBrightness == Brightness.light
      ? Color.fromRGBO(
    r - (r  * strength).round(),
    g - (g * strength).round(),
    b - (b * strength).round(),
    1,
  )
      : Color.fromRGBO(
    r + ((255 - r) * strength).round(),
    g + ((255 - g) * strength).round(),
    b + ((255 - b) * strength).round(),
    1,
  );
}

extension TonalElevation on Color{
  Color tonalElevation(Elevation level, BuildContext context){
    return _tonalElevation(color: this, level: level, context: context);
  }
}