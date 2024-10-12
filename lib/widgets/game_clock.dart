import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter{
  final BuildContext context;
  final Timer timer;
  final Duration duration;
  final double fractionElapsed;

  ClockPainter({
    required this.context,
    required this.timer,
    required this.duration,
    required this.fractionElapsed
  });

  @override
  bool shouldRepaint(ClockPainter oldDelegate){
    return timer.tick != oldDelegate.timer.tick || fractionElapsed != oldDelegate.fractionElapsed;
  }

  @override
  void paint(Canvas canvas, Size size){
    final double strokeWidth = size.width / 10;
    canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        - math.pi / 2,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withOpacity(0.32)
    );
    canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        - math.pi / 2,
        - 2 * math.pi * (1 - fractionElapsed),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..color = color
    );
    final textPainter = TextPainter(
        text: TextSpan(
            text: (math.max(duration.inSeconds - timer.tick, 0)).toString(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: size.width - (2 * strokeWidth) * 3, // The 3 acts as a padding ... hopefully
                color: Colors.white
            )
        ),
        textDirection: TextDirection.ltr
    );
    textPainter.layout(
        maxWidth: size.width - (2 * strokeWidth)
    );
    textPainter.paint(
        canvas,
        Offset(
            size.width / 2 - textPainter.width / 2,
            size.height / 2 - textPainter.height / 2
        )
    );
  }
  Color get color {
    const startColor = Colors.blue;
    const endColor = Colors.red;
    return Color.fromRGBO(
        ((endColor.red - startColor.red) * (fractionElapsed) + startColor.red).toInt(),
        ((endColor.green - startColor.green) * (fractionElapsed) + startColor.green).toInt(),
        ((endColor.blue - startColor.blue) * (fractionElapsed) + startColor.blue).toInt(),
        1
    );
  }
}