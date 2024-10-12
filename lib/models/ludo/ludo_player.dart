import 'package:ludo/models/ludo/ludo_seed.dart';

class LudoPlayer{
  final List<LudoSeed> seeds;
  LudoPlayer({
    required this.seeds,
  });

  static LudoPlayer fromMap(Map<String, dynamic> data){
    return LudoPlayer(seeds: List.from(data['seeds']).map((s) => LudoSeed.fromMap(s)).toList());
  }
  Map <String, dynamic> toMap(){
    return {
      'seeds': seeds.map((s) => s.toMap()).toList()
    };
  }
}