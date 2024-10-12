import 'package:ludo/models/ludo/ludo_player.dart';
import 'package:ludo/models/ludo/ludo_seed.dart';
import 'package:ludo/models/ludo/num_ludo_players.dart';
import 'package:ludo/models/ludo/position.dart';

class LudoGameState {
  List<LudoPlayer> ludoPlayers;
  List<int> diceValues;
  int turn;
  int? winner;

  LudoGameState({
    required this.ludoPlayers,
    required this.diceValues,
    required this.turn,
    this.winner,
  });

  static LudoGameState fromMap(Map<String, dynamic> data){ 
    return LudoGameState(
      ludoPlayers: List.from(data['ludoPlayers']).map((s) => LudoPlayer.fromMap(s)).toList(),
      diceValues: (data['diceValues'] as List).cast<int>(),
      turn: data['turn'],
      winner: data['winner']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ludoPlayers': ludoPlayers.map((s) => s.toMap()).toList(),
      'diceValues': diceValues,
      'turn': turn,
      'winner': winner,
    };
  }

  static LudoGameState initialGameState(NumLudoPlayers numberOfPlayers){
    final List<LudoSeed> greenSeeds = [
      LudoSeed(color: SeedColor.green, position: LudoPosition(3, 3)),
      LudoSeed(color: SeedColor.green, position: LudoPosition(4, 3)),
      LudoSeed(color: SeedColor.green, position: LudoPosition(3, 4)),
      LudoSeed(color: SeedColor.green, position: LudoPosition(4, 4)),
    ];
    final List<LudoSeed> yellowSeeds = [
      LudoSeed(color: SeedColor.yellow, position: LudoPosition(12, 3)),
      LudoSeed(color: SeedColor.yellow, position: LudoPosition(13, 3)),
      LudoSeed(color: SeedColor.yellow, position: LudoPosition(12, 4)),
      LudoSeed(color: SeedColor.yellow, position: LudoPosition(13, 4)),
    ];
    final List<LudoSeed> redSeeds = [
      LudoSeed(color: SeedColor.red, position: LudoPosition(3, 12)),
      LudoSeed(color: SeedColor.red, position: LudoPosition(4, 12)),
      LudoSeed(color: SeedColor.red, position: LudoPosition(3, 13)),
      LudoSeed(color: SeedColor.red, position: LudoPosition(4, 13)),
    ];
    final List<LudoSeed> blueSeeds = [
      LudoSeed(color: SeedColor.blue, position: LudoPosition(12, 12)),
      LudoSeed(color: SeedColor.blue, position: LudoPosition(13, 12)),
      LudoSeed(color: SeedColor.blue, position: LudoPosition(12, 13)),
      LudoSeed(color: SeedColor.blue, position: LudoPosition(13, 13)),
    ];
    final players = switch(numberOfPlayers){
      NumLudoPlayers.two => [
        LudoPlayer(seeds: [...greenSeeds, ...yellowSeeds]),
        LudoPlayer(seeds: [...blueSeeds, ...redSeeds]),
      ],
      NumLudoPlayers.four => [
        LudoPlayer(seeds: greenSeeds),
        LudoPlayer(seeds: yellowSeeds),
        LudoPlayer(seeds: blueSeeds),
        LudoPlayer(seeds: redSeeds),
      ]
    };
    return LudoGameState(
      ludoPlayers: players,
      diceValues: [0, 0],
      turn: 0
    );
  }
}