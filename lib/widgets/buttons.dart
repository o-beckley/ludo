import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ludo/theme/color_theme.dart';

class CustomWideButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;
  final Color? backgroundColor;
  final bool disabled;

  const CustomWideButton({
    required this.label,
    this.onTap,
    this.trailing,
    this.color,
    this.backgroundColor,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.32 : 1,
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: backgroundColor ?? context.watch<UIColors>().primary,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 60,
            child: trailing == null
            ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color ?? context.watch<UIColors>().onPrimaryContainer,
                  ),
                ),
              ),
            )
            : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: color ?? context.watch<UIColors>().onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  trailing!
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomFilledButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final Color? backgroundColor;
  final bool disabled;

  const CustomFilledButton({
    required this.label,
    this.onTap,
    this.color,
    this.backgroundColor,
    this.disabled = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.32 : 1,
      child: Material(
        color: backgroundColor ?? context.watch<UIColors>().primary,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(25),
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color ?? context.watch<UIColors>().onPrimaryContainer
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool disabled;

  const CustomOutlinedButton({
    required this.label,
    this.onTap,
    this.color,
    this.disabled = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.32 : 1,
      child: Material(
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: color ?? context.watch<UIColors>().onSurface,
                width: 1
              )
            ),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: color ?? context.watch<UIColors>().onSurface
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool disabled;

  const CustomTextButton({
    required this.label,
    this.onTap,
    this.color,
    this.disabled = false,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.32 : 1,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: SizedBox(
          height: 40,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color ?? Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSvgIconButton extends StatelessWidget {
  final String svgIconPath;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double radius;
  final bool disabled;

  const CustomSvgIconButton({
    required this.svgIconPath,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.radius = 40,
    this.disabled = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.32 : 1,
      child: Material(
        color: backgroundColor ?? context.watch<UIColors>().surfaceContainer,
        borderRadius: BorderRadius.circular(radius / 2),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(radius / 2),
          child: SizedBox.square(
            dimension: radius,
            child: Center(
              child: SvgPicture.asset(
                svgIconPath,
                colorFilter: ColorFilter.mode(
                  iconColor ?? context.watch<UIColors>().onSurface,
                  BlendMode.srcIn
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double radius;
  final bool disabled;

  const CustomIconButton({
    required this.iconData,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.radius = 40,
    this.disabled = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.32 : 1,
      child: Material(
        color: backgroundColor ?? context.watch<UIColors>().surfaceContainer,
        borderRadius: BorderRadius.circular(radius / 2),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(radius / 2),
          child: SizedBox.square(
            dimension: radius,
            child: Center(
              child: Icon(
                iconData,
                color: iconColor ?? context.watch<UIColors>().onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
