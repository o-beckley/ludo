import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ludo/theme/color_theme.dart';
import 'package:ludo/widgets/placeholders.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? radius;
  final double? width;
  final double? height;
  final BoxShape shape;

  const CustomNetworkImage({
    this.imageUrl,
    this.radius,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? (radius != null && shape == BoxShape.circle ? radius! * 2 : null),
      height: height ?? (radius != null && shape == BoxShape.circle ? radius! * 2 : null),
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.watch<UIColors>().surfaceContainer,
            borderRadius: radius != null && shape != BoxShape.circle
              ? BorderRadius.circular(radius!)
              : null,
            shape: shape
          ),
          child: imageUrl != null
          ? CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            errorWidget: (context, url, _) => ImagePlaceholder(radius: radius),
          )
          : ImagePlaceholder(
            radius: radius,
            shape: shape,
            width: width,
            height: height,
          )
      ),
    );
  }
}