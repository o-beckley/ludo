import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ludo/models/ludo/ludo_game_state.dart';
import 'package:ludo/models/ludo/num_ludo_players.dart';
import 'package:ludo/models/ludo/ludo_dice.dart';
import 'package:ludo/models/ludo/ludo_player.dart';
import 'package:ludo/models/ludo/ludo_seed.dart';
import 'package:ludo/models/ludo/position.dart';
import 'package:ludo/services/ludo_service.dart';


class LudoEngine extends ChangeNotifier{
  late LudoGameState _gameState;

  LudoEngine({
    required NumLudoPlayers numberOfPlayers
  }){
    _gameState = LudoGameState.initialGameState(numberOfPlayers);
    _createPaths();
  }

  bool _isPlaying = false;
  bool _shouldPlayAgain = false;
  num? _selectedSeedId;
  List<LudoSeed> _seedsOnSelectedSquare = [];


  int get turn => _gameState.turn;
  bool get hasRolled => _gameState.diceValues.any((d) => d != 0);
  List<int> get diceValues => _gameState.diceValues;
  int? get winner => _gameState.winner;
  List<LudoPlayer> get ludoPlayers => _gameState.ludoPlayers;
  num? get selectedSeedId => _selectedSeedId;
  List<LudoSeed> get seedsOnSelectedSquare => _seedsOnSelectedSquare;
  LudoGameState get gameState => _gameState;

  // seed paths
  Map<SeedColor, List<LudoPosition>> _paths = {};

  void _createPaths(){
    List<LudoPosition> greenPath = [];
    List<LudoPosition> yellowPath = [];
    List<LudoPosition> redPath = [];
    List<LudoPosition> bluePath = [];

    // green path
    greenPath.addAll(List.generate(5, (index) => index + 2).map((e) => LudoPosition(e, 7)));
    greenPath.addAll(List.generate(6, (index) => 6 - index).map((e) => LudoPosition(7, e)));
    greenPath.add(LudoPosition(8, 1));
    greenPath.addAll(List.generate(6, (index) => index + 1).map((e) => LudoPosition(9, e)));
    greenPath.addAll(List.generate(6, (index) => index + 10).map((e) => LudoPosition(e, 7)));
    greenPath.add(LudoPosition(15, 8));
    greenPath.addAll(List.generate(6, (index) => 15 - index).map((e) => LudoPosition(e, 9)));
    greenPath.addAll(List.generate(6, (index) => index + 10).map((e) => LudoPosition(9, e)));
    greenPath.add(LudoPosition(8, 15));
    greenPath.addAll(List.generate(6, (index) => 15 - index).map((e) => LudoPosition(7, e)));
    greenPath.addAll(List.generate(6, (index) => 6 - index).map((e) => LudoPosition(e, 9)));
    greenPath.addAll(List.generate(7, (index) => index + 1).map((e) => LudoPosition(e, 8)));

    // yellow path
    yellowPath.addAll(List.generate(5, (index) => index + 2).map((e) => LudoPosition(9, e)));
    yellowPath.addAll(List.generate(6, (index) => index + 10).map((e) => LudoPosition(e, 7)));
    yellowPath.add(LudoPosition(15, 8));
    yellowPath.addAll(List.generate(6, (index) => 15 - index).map((e) => LudoPosition(e, 9)));
    yellowPath.addAll(List.generate(6, (index) => index + 10).map((e) => LudoPosition(9, e)));
    yellowPath.add(LudoPosition(8, 15));
    yellowPath.addAll(List.generate(6, (index) => 15 - index).map((e) => LudoPosition(7, e)));
    yellowPath.addAll(List.generate(6, (index) => 6 - index).map((e) => LudoPosition(e, 9)));
    yellowPath.add(LudoPosition(1, 8));
    yellowPath.addAll(List.generate(6, (index) => index + 1).map((e) => LudoPosition(e, 7)));
    yellowPath.addAll(List.generate(6, (index) => 6 - index).map((e) => LudoPosition(7, e)));
    yellowPath.addAll(List.generate(7, (index) => index + 1).map((e) => LudoPosition(8, e)));

    // blue path
    bluePath.addAll(List.generate(5, (index) => 14 - index).map((e) => LudoPosition(e, 9)));
    bluePath.addAll(List.generate(6, (index) => index + 10).map((e) => LudoPosition(9, e)));
    bluePath.add(LudoPosition(8, 15));
    bluePath.addAll(List.generate(6, (index) => 15 - index).map((e) => LudoPosition(7, e)));
    bluePath.addAll(List.generate(6, (index) => 6 - index).map((e) => LudoPosition(e, 9)));
    bluePath.add(LudoPosition(1, 8));
    bluePath.addAll(List.generate(6, (index) => index + 1).map((e) => LudoPosition(e, 7)));
    bluePath.addAll(List.generate(6, (index) => 6 - index).map((e) => LudoPosition(7, e)));
    bluePath.add(LudoPosition(8, 1));
    bluePath.addAll(List.generate(6, (index) => index + 1).map((e) => LudoPosition(9, e)));
    bluePath.addAll(List.generate(6, (index) => index + 10).map((e) => LudoPosition(e, 7)));
    bluePath.addAll(List.generate(7, (index) => 15 - index).map((e) => LudoPosition(e, 8)));

    // red path
    redPath.addAll(List.generate(5, (index) => 14 - index).map((e) => LudoPosition(7, e)));
    redPath.addAll(List.generate(6, (index) => 6 - index).map((e) => LudoPosition(e, 9)));
    redPath.add(LudoPosition(1, 8));
    redPath.addAll(List.generate(6, (index) => index + 1).map((e) => LudoPosition(e, 7)));
    redPath.addAll(List.generate(6, (index) => 6 - index).map((e) => LudoPosition(7, e)));
    redPath.add(LudoPosition(8, 1));
    redPath.addAll(List.generate(6, (index) => index + 1).map((e) => LudoPosition(9, e)));
    redPath.addAll(List.generate(6, (index) => index + 10).map((e) => LudoPosition(e, 7)));
    redPath.add(LudoPosition(15, 8));
    redPath.addAll(List.generate(6, (index) => 15 - index).map((e) => LudoPosition(e, 9)));
    redPath.addAll(List.generate(6, (index) => index + 10).map((e) => LudoPosition(9, e)));
    redPath.addAll(List.generate(7, (index) => 15 - index).map((e) => LudoPosition(8, e)));

    _paths = {
      SeedColor.green : greenPath,
      SeedColor.yellow : yellowPath,
      SeedColor.blue : bluePath,
      SeedColor.red: redPath,
    };
  }

  void rollDice(BuildContext context) async {
    /// generates values on the dice for the player with [turn]
    if(hasRolled){
      return;
    }
    _gameState.diceValues = LudoDice.generate();
    _shouldPlayAgain = _gameState.diceValues.every((value) => value == 6);
    notifyListeners();

    if(!_hasValidMove){
      await Future.delayed(const Duration(seconds: 2)); // looks nicer when you wait a bit
      _switchTurns();
    }

    if(context.mounted){
      _updateServerState(context);
    }
  }

  void selectSeed(LudoPosition position){
    /// selects a seed for a move to be played on
    _resetSeeds();
    final seeds = _gameState.ludoPlayers[turn].seeds;
    _seedsOnSelectedSquare = seeds.where((seed) => seed.position == position).toList();
    for(var seed in _seedsOnSelectedSquare.reversed){
      _selectedSeedId = seed.id;
      notifyListeners();
      break;
    }
  }

  void deselectAllSeeds(){
    _selectedSeedId = null;
  }

  Future<bool> playMove(TickerProviderStateMixin gameScreenState, num seedId, int steps) async{
    /// this method should be called from the game screen
    /// [gameScreenState] is used to create tickers for the animations in [_animate()]
    if(_isPlaying){
      return false;
    }
    _isPlaying = true;
    LudoSeed seed = _gameState.ludoPlayers[turn].seeds.firstWhere((s) => s.id == seedId);
    List<LudoPosition> result = _moveSeed(seed, steps);

    if(result[0] != result[1]){ // the seed moved
      await _animate(gameScreenState, seed, result[0], result[1], Duration(milliseconds: 200 * steps));
      int index = _gameState.diceValues.indexOf(steps);
      // removes a value from the dice when the player plays a move
      _gameState.diceValues[index] = 0;

      final opponentSeeds = _gameState.ludoPlayers
      .where((player) => player != _gameState.ludoPlayers[_gameState.turn])
      .expand((player) => player.seeds);
      for (var opponentSeed in opponentSeeds){
        if(seed.position == opponentSeed.position){
          // moves opponent seed back to starting position when there is a collision
          // and moves the players seed to the finish
          await _animate(gameScreenState, opponentSeed, opponentSeed.position, opponentSeed.startingPosition, const Duration(seconds: 1));
          await _animate(gameScreenState, seed, seed.position, _paths[seed.color]!.last, const Duration(seconds: 1));
          _resetSeeds();
          break;
        }
      }

      // if all the values have been removed from the dice 
      // or there is no valid move, then switch turns
      if(_gameState.diceValues.every((element) => element == 0) || !_hasValidMove) _switchTurns();

      _isPlaying = false;
      _checkForWin();
      if(gameScreenState.mounted){
        _updateServerState(gameScreenState.context);
      }
      return true;
    }
    _isPlaying = false;
    return false;
  }

  List<LudoPosition> _moveSeed(LudoSeed seed, int steps){
    /// calculates the newPosition given the oldPosition and [steps]
    /// returns [oldPosition, newPosition]
    /// oldPosition and newPosition will be the same if the seed did not move
    List<LudoPosition> path = _paths[seed.color]!;
    LudoPosition oldPosition = seed.position;
    LudoPosition newPosition = seed.position;
    if(!seed.hasMoved){
      if(steps == 6){ // the seed can only come out of base if the player gets a 6 on a die
        newPosition = path[0];
      }
    }
    else{
      int currentPosition = path.indexOf(seed.position);
      if(currentPosition + steps + 1 <= path.length){ // can not apply a move that would take you further than the finish line
        newPosition = path[currentPosition + steps];
      }
    }
    return [oldPosition, newPosition];
  }

  Future<void> _animate (
    /// animates any seed from [oldPosition] to [newPosition]
    TickerProviderStateMixin gameScreenState,
    LudoSeed seed,
    LudoPosition oldPosition,
    LudoPosition newPosition,
    Duration duration,
  ) async {
    final seedController = AnimationController(vsync: gameScreenState, duration: duration);
    seedController.addListener(() {
      seed.position.x += (newPosition.x - oldPosition.x) * seedController.value;
      seed.position.y += (newPosition.y - oldPosition.y) * seedController.value;
      notifyListeners();
    });
    await seedController.forward().then((value) => seedController.dispose());
  }

  void _switchTurns() {
    _resetSeeds();
    _resetDice();
    if(!_shouldPlayAgain){ // switch turns
      _gameState.turn = (_gameState.turn + 1) % _gameState.ludoPlayers.length;
    }
    _shouldPlayAgain = false;
    notifyListeners();
  }

  void _resetDice(){
    _gameState.diceValues = [0, 0];
  }

  void _resetSeeds(){
    deselectAllSeeds();
    _seedsOnSelectedSquare = [];
    notifyListeners();
  }

  void _checkForWin(){
    /// checks if any particular player has carried all their seeds to the finish line
    for (int i = 0; i < _gameState.ludoPlayers.length; i++){
      List seedColors = _gameState.ludoPlayers[i].seeds.map((e) => e.color).toSet().toList();
      if(_gameState.ludoPlayers[i].seeds.every((seed) => seedColors.any((color) => seed.position == _paths[color]!.last))){
        log('player $i wins');
        //TODO: add the win to the player's stats
        _gameState.winner = i;
        notifyListeners();
        break;

      }
    }
  }

  bool get _hasValidMove{
    List<int> numPossibleMoves = List.generate(8, (index) => 0);
    for(int steps in _gameState.diceValues){
      for(int i = 0; i < _gameState.ludoPlayers[_gameState.turn].seeds.length; i++){
        final positions = _moveSeed(_gameState.ludoPlayers[_gameState.turn].seeds[i], steps);
        if(positions[0] != positions[1]){
          numPossibleMoves[i] += 1;
        }
      }
    }
    return numPossibleMoves.any((element) => element != 0);
  }

  void _updateServerState(BuildContext context){
    Provider.of<LudoService>(context, listen: false)
        .updateServerGameState(context, _gameState);
  }

  void updateGameState(LudoGameState newState, TickerProviderStateMixin gameScreenState) async {
    List<LudoSeed> oldSeeds = _gameState.ludoPlayers.expand((p) => p.seeds).toList();
    try{
      await Future.forEach(
        newState.ludoPlayers.expand((p) => p.seeds),
        (newSeed){
          var targetSeed = oldSeeds.firstWhere((s) => s.id == newSeed.id);
          if(newSeed.position != targetSeed.position){
            return _animate(
              gameScreenState,
              targetSeed,
              targetSeed.position,
              newSeed.position,
              const Duration(milliseconds: 500)
            );
          }
        }
      );
      _gameState = newState;
      notifyListeners();
    }
    catch(e){
      log(e.toString());
    }
  }
}