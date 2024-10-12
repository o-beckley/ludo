import 'package:ludo/models/ludo/ludo_game_state.dart';
import 'package:ludo/models/ludo/num_ludo_players.dart';

enum RoomState{waiting, started, ended}

class LudoRoom {
  final String? id;
  final NumLudoPlayers numLudoPlayers;
  final List<String> players;
  final bool private;
  final RoomState state;
  final LudoGameState gameState;

  LudoRoom({
    required this.numLudoPlayers,
    required this.players,
    required this.private,
    required this.state,
    required this.gameState,
    this.id
  });

  bool get roomFull {
    return switch (numLudoPlayers) {
      NumLudoPlayers.two => players.length >= 2,
      NumLudoPlayers.four => players.length >= 4
    };
  }

  int get numPlayers {
    return switch(numLudoPlayers){
      NumLudoPlayers.two => 2,
      NumLudoPlayers.four => 4,
    };
  }

  static LudoRoom fromMap(Map<String, dynamic> data) {
    return LudoRoom(
      id: data['id'],
      numLudoPlayers: switch (data['numPlayers']){
        2 => NumLudoPlayers.two,
        4 => NumLudoPlayers.four,
        _ => NumLudoPlayers.four,
      },
      players: (data['players'] as List).cast<String>(),
      private: data['private'] ?? false,
      state: switch(data['state']){
        'waiting' => RoomState.waiting,
        'started' => RoomState.started,
        'ended' => RoomState.ended,
        _ => RoomState.ended
      },
      gameState: LudoGameState.fromMap(data['gameState'])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numPlayers': switch (numLudoPlayers) {
        NumLudoPlayers.two => 2,
        NumLudoPlayers.four => 4
      },
      'players': players,
      'private': private,
      'state': switch (state) {
        RoomState.waiting => 'waiting',
        RoomState.started => 'started',
        RoomState.ended => 'ended'
      },
      'gameState': gameState.toMap()
    };
  }

  LudoRoom copyWith({
    String? id,
    NumLudoPlayers? numLudoPlayers,
    List<String>? players,
    bool? private,
    RoomState? state,
    LudoGameState? gameState,
  }) {
    return LudoRoom(
      id: id ?? this.id,
      numLudoPlayers: numLudoPlayers ?? this.numLudoPlayers,
      players: players ?? this.players,
      private: private ?? this.private,
      state: state ?? this.state,
      gameState: gameState ?? this.gameState
    );
  }
}
