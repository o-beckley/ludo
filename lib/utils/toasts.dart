import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ludo/theme/color_theme.dart';
import 'package:ludo/widgets/tonal_elevation.dart';
class Toasts {

  static showToast(String message, BuildContext context) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: context.read<UIColors>().surfaceContainer.tonalElevation(Elevation.level5, context),
      textColor: context.read<UIColors>().onSurface,
      fontSize: 14.0,
    );
  }
}