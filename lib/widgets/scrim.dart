import 'package:flutter/material.dart';

class Scrim extends StatelessWidget {
  final Widget child;
  final bool active;
  const Scrim({
    required this.child,
    this.active = false,
    super.key});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: active ? 0.32 : 1,
      child: child,
    );
  }
}