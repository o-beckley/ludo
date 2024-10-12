import 'package:flutter/material.dart';
import 'color_swatch_generator.dart';

MaterialColor primaryColor = createColorSwatch(const Color(0xff8e6cef));
MaterialColor secondaryColor = createColorSwatch(const Color(0xffffb632));
MaterialColor tertiaryColor = createColorSwatch(const Color(0xff8e6cef));
MaterialColor errorColor = createColorSwatch(const Color(0xfffa3636));
MaterialColor neutralColor = createColorSwatch(const Color(0xff888888));
MaterialColor neutralVariantColor = createColorSwatch(const Color(0xff342f3f));
Color shadowColor = const Color(0xff373737);

ColorScheme lightScheme =  ColorScheme.light(
  primary: primaryColor[40]!,
  onPrimary: primaryColor[100]!,
  primaryContainer: primaryColor[90],
  onPrimaryContainer: primaryColor[10],
  inversePrimary: primaryColor[80],

  secondary: secondaryColor[40]!,
  onSecondary: secondaryColor[100]!,
  secondaryContainer: secondaryColor[90],
  onSecondaryContainer: secondaryColor[10],

  tertiary: tertiaryColor[40],
  onTertiary: tertiaryColor[100],
  tertiaryContainer: tertiaryColor[90],
  onTertiaryContainer: tertiaryColor[10],

  error: errorColor[40]!,
  onError: errorColor[100]!,
  errorContainer: errorColor[90],
  onErrorContainer: errorColor[10],

  outline: neutralVariantColor[50],
  outlineVariant: neutralVariantColor[80],

  surface: neutralColor[98]!,
  onSurface: neutralColor[10]!,

  inverseSurface: neutralColor[20],
  onInverseSurface: neutralColor[95],

  shadow: shadowColor.withOpacity(0.25)
);

ColorScheme darkScheme =  ColorScheme.dark(
  primary: primaryColor[80]!,
  onPrimary: primaryColor[20]!,
  primaryContainer: primaryColor[30],
  onPrimaryContainer: primaryColor[90],
  inversePrimary: primaryColor[40],

  secondary: secondaryColor[80]!,
  onSecondary: secondaryColor[20]!,
  secondaryContainer: secondaryColor[30],
  onSecondaryContainer: secondaryColor[90],

  tertiary: tertiaryColor[80],
  onTertiary: tertiaryColor[20],
  tertiaryContainer: tertiaryColor[30],
  onTertiaryContainer: tertiaryColor[90],

  error: errorColor[80]!,
  onError: errorColor[20]!,
  errorContainer: errorColor[30],
  onErrorContainer: errorColor[90],

  outline: neutralVariantColor[60],
  outlineVariant: neutralVariantColor[30],

  surface: neutralColor[6]!,
  onSurface: neutralColor[90]!,

  inverseSurface: neutralColor[80],
  onInverseSurface: neutralColor[5],

  shadow: shadowColor
);

class UIColors extends ChangeNotifier{
  ValueNotifier darkMode = ValueNotifier(false);
  UIColors(){
    darkMode.addListener((){
      notifyListeners();
    });
  }
  // bool get darkMode => MediaQuery.of(context).platformBrightness == Brightness.dark;
  final Color _primary = const Color(0xff8e6cef);
  final Color _onPrimaryContainer = const Color(0xffffffff);

  final Color _error =  const Color(0xfffa3636);
  final Color _success = const Color(0xff5fb567);

  final Color _surfaceLight = const Color(0xffffffff);
  final Color _surfaceDark = const Color(0xff1d182a);

  final Color _surfaceContainerLight = const Color(0xfff4f4f4);
  final Color _surfaceContainerDark = const Color(0xff342f3f);

  final Color _onSurfaceLight = const Color(0xff272727);
  final Color _onSurfaceDark = const Color(0xffffffff);

  final Color _outlineLight = const Color(0xff939393);
  final Color _outlineDark = const Color(0xff8e8b94);

  Color get primary => _primary;
  Color get onPrimaryContainer => _onPrimaryContainer;
  Color get error => _error;
  Color get success => _success;
  Color get surface => darkMode.value ? _surfaceDark : _surfaceLight;
  Color get surfaceContainer => darkMode.value ? _surfaceContainerDark : _surfaceContainerLight;
  Color get onSurface => darkMode.value ? _onSurfaceDark : _onSurfaceLight;
  Color get outline => darkMode.value ? _outlineDark : _outlineLight;
}