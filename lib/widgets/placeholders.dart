import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ludo/theme/color_theme.dart';
import 'package:ludo/widgets/tonal_elevation.dart';


class ImagePlaceholder extends StatelessWidget {
  final double? radius;
  final double? width;
  final double? height;
  final BoxShape shape;

  const ImagePlaceholder({
    this.radius,
    this.width, this.height,
    this.shape = BoxShape.rectangle,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? (radius != null && shape == BoxShape.circle ? radius! * 2 : null),
      height: height ?? (radius != null && shape == BoxShape.circle ? radius! * 2 : null),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: shape,
            borderRadius: radius != null && shape != BoxShape.circle
                ? BorderRadius.circular(radius!)
                : null,
            color: (context).watch<UIColors>().surfaceContainer.tonalElevation(Elevation.level2, context)
        ),
      ),
    );
  }
}

class TextPlaceHolder extends StatelessWidget {
  final double height, width;
  const TextPlaceHolder({
    required this.height,
    required this.width,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height/2),
          color: (context).watch<UIColors>().surfaceContainer.tonalElevation(Elevation.level2, context)
        )
      ),
    );
  }
}