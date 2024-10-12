import 'package:flutter/material.dart';
import 'package:ludo/models/ludo/position.dart';

enum SeedColor {green, yellow, red, blue}

class LudoSeed{
  SeedColor color;
  LudoPosition position;
  final LudoPosition startingPosition;
  Color materialColor;

  LudoSeed({
    required this.color,
    required this.position,
    LudoPosition? startingPosition,
  }): startingPosition = startingPosition ?? LudoPosition(position.x, position.y),
      materialColor = switch(color){
        SeedColor.green => Colors.green,
        SeedColor.yellow => Colors.yellow,
        SeedColor.red => Colors.red,
        SeedColor.blue => Colors.blue
      };

  static LudoSeed fromMap(Map<String, dynamic> data){
    return LudoSeed(
      color: switch(data['color']){
        'green' => SeedColor.green,
        'yellow' => SeedColor.yellow,
        'red' => SeedColor.red,
        'blue' => SeedColor.blue,
        _ => SeedColor.green // wont come to this
      },
      position: LudoPosition(data['position'][0], data['position'][1]),
      startingPosition: LudoPosition(data['startingPosition'][0], data['startingPosition'][1]),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'color': switch(color){
        SeedColor.blue => 'blue',
        SeedColor.green => 'green',
        SeedColor.red => 'red',
        SeedColor.yellow => 'yellow'
      },
      'position': [position.x, position.y],
      'startingPosition': [startingPosition.x, startingPosition.y],
    };
  }

  @override
  String toString(){
    return '{color: ${color.name}, position: ${position.toString()}}';
  }

  bool get hasMoved => position != startingPosition;

  num get id => 100 * startingPosition.x + startingPosition.y;
}