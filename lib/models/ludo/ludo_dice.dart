import 'dart:math';

class LudoDice{
  static List<int> generate({int? seed}){
    var random = Random(seed);
    int dice1 = random.nextInt(6) + 1;
    int dice2 = random.nextInt(6) + 1;
    return [dice1, dice2];
  }
}