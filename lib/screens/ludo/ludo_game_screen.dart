import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ludo/configs/asset_paths.dart';
import 'package:ludo/game_engine/ludo_game_engine.dart';
import 'package:ludo/models/ludo/ludo_room.dart';
import 'package:ludo/models/ludo/num_ludo_players.dart';
import 'package:ludo/models/general/player.dart';
import 'package:ludo/models/ludo/position.dart';
import 'package:ludo/services/auth_service.dart';
import 'package:ludo/services/ludo_service.dart';
import 'package:ludo/widgets/custom_network_image.dart';
import 'package:ludo/widgets/buttons.dart';

class LudoGameScreen extends StatefulWidget {
  const LudoGameScreen({super.key});

  @override
  State<LudoGameScreen> createState() => LudoGameScreenState();
}

class LudoGameScreenState extends State<LudoGameScreen>
    with TickerProviderStateMixin {
  late Future<ui.Image> boardImage;
  late LudoEngine game;
  late List<Future<Player?>> players;
  late Future<Stream<LudoRoom?>> roomSnapshots;
  StreamSubscription<LudoRoom?>? roomSubscription;
  late final double boardSize;

  Future<ui.Image> _getBoardImage() async {
    final data = await rootBundle.load(AssetPaths.ludoBoard);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  void initState() {
    super.initState();
    boardSize = 0.9.sw;
    final ludoService = Provider.of<LudoService>(context, listen: false);
    players = ludoService.currentRoom!.players
        .map((p) => ludoService.getPlayer(p))
        .toList();
    boardImage = _getBoardImage();
    game = LudoEngine(numberOfPlayers: ludoService.currentRoom!.numLudoPlayers);
    game.addListener(() {
      setState(() {});
    });
    if (ludoService.currentRoom != null &&
        ludoService.currentRoom?.id != null) {
      roomSnapshots = ludoService.getRoomSnapshots();
      roomSnapshots.then((snapshots) {
        roomSubscription = snapshots.listen((room) {
          if (room != null) {
            game.updateGameState(room.gameState, this);
          }
        });
      });
    }
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    List<String> images = [
      AssetPaths.dice1,
      AssetPaths.dice2,
      AssetPaths.dice3,
      AssetPaths.dice4,
      AssetPaths.dice5,
      AssetPaths.dice6
    ];
    Future.wait(images.map((image) => precacheImage(AssetImage(image), context)));
  }

  @override
  void dispose() {
    game.removeListener(() {
      setState(() {});
    });
    super.dispose();
    roomSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ludoService = Provider.of<LudoService>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          ...List.generate(
            ludoService.currentRoom!.numPlayers,
            (index) {
              return FutureBuilder(
                future: players[index],
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return PlayerSection(
                      index: index,
                      numPlayers: ludoService.currentRoom!.numLudoPlayers,
                      player: snapshot.data!,
                      game: game
                    );
                  }
                  return const SizedBox.shrink();
                }
              );
            }
          ),
          Align( // board
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: game,
              builder: (context, _) {
                return FutureBuilder(
                  future: boardImage,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTapDown: (details) {
                          int x = ((details.localPosition.dx / boardSize) * 15).ceil();
                          int y = ((details.localPosition.dy / boardSize) * 15).ceil();
                          game.selectSeed(LudoPosition(x, y));
                        },
                        child: SizedBox.square(
                          dimension: boardSize,
                          child: CustomPaint(
                            painter: LudoPainter(
                              context: context,
                              boardImage: snapshot.data!,
                              game: game,
                            ),
                          )
                        ),
                      );
                    }
                    return SizedBox.square(
                      dimension: boardSize,
                    );
                  }
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerSection extends StatefulWidget {
  final int index;
  final NumLudoPlayers numPlayers;
  final LudoEngine game;
  final Player player;

  const PlayerSection({
    required this.index,
    required this.numPlayers,
    required this.player,
    required this.game,
    super.key
  });

  @override
  State<PlayerSection> createState() => _PlayerSectionState();
}

class _PlayerSectionState extends State<PlayerSection> with TickerProviderStateMixin {
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 50, horizontal: 20);
  late Alignment alignment;
  late final int playerIndex;
  @override
  void initState() {
    super.initState();
    alignment = switch (widget.index) {
      0 => Alignment.topLeft,
      1 => widget.numPlayers == NumLudoPlayers.two
          ? Alignment.bottomRight
          : Alignment.topRight,
      2 => Alignment.bottomRight,
      3 => Alignment.bottomLeft,
      _ => Alignment.center
    };
    final ludoService = Provider.of<LudoService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    playerIndex = ludoService.currentRoom!.players.indexOf(authService.firebaseUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      CustomNetworkImage(
        imageUrl: widget.player.profileImageUrl,
        radius: 0.1.sw,
        shape: BoxShape.circle,
      ),
      if(playerIndex == widget.index)
        _buildDice()
      else
        const SizedBox.shrink(),
    ];
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.index == 0 || widget.index == 3
          ? children
          : children.reversed.toList() // this is to always show the profile picture on the outside
        ),
      ),
    );
  }

  String _getDiceImage(int num) {
    return switch (num) {
      1 => AssetPaths.dice1,
      2 => AssetPaths.dice2,
      3 => AssetPaths.dice3,
      4 => AssetPaths.dice4,
      5 => AssetPaths.dice5,
      6 => AssetPaths.dice6,
      _ => ''
    };
  }

  Widget _buildDie(int index) {
    assert(index == 0 || index == 1);
    final ludoService = Provider.of<LudoService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    return widget.game.diceValues[index] != 0
    ? GestureDetector(
      onTap: () {
        if (ludoService.currentRoom != null &&
            authService.firebaseUser != null &&
            ludoService.currentRoom!.gameState.turn == playerIndex) {
          if (widget.game.selectedSeedId != null) {
            widget.game.playMove(this, widget.game.selectedSeedId!,
                widget.game.diceValues[index]);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox.square(
          dimension: 30,
          child: Image.asset(
            _getDiceImage(widget.game.diceValues[index]),
            fit: BoxFit.cover,
          ),
        ),
      ),
    )
    : const SizedBox.shrink();
  }

  Widget _buildDice() {
    final ludoService = Provider.of<LudoService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (ludoService.currentRoom != null &&
        authService.firebaseUser != null &&
        ludoService.currentRoom!.gameState.turn == playerIndex){
      return widget.game.hasRolled
      ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDie(0),
            _buildDie(1),
          ]
        ),
      )
      : GestureDetector(
        onTap: () {
          widget.game.rollDice(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomFilledButton(
            label: 'roll dice',
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            onTap: () {
              widget.game.rollDice(context);
            },
          ),
        )
      );
    }
    return const SizedBox.shrink();
  }
}

class LudoPainter extends CustomPainter {
  BuildContext context;
  ui.Image boardImage;
  LudoEngine game;
  LudoPainter({
    required this.context,
    required this.boardImage,
    required this.game,
  });

  @override
  bool shouldRepaint(LudoPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double tileSize = size.width / 15;

    // draw board
    canvas.drawImageRect(
      boardImage,
      Rect.fromLTWH(0, 0, boardImage.width.toDouble(), boardImage.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
    );

    // draw seeds
    // for var seed in seeds
    for (var seed in game.ludoPlayers.map((player) => player.seeds).expand((seeds) => seeds)) {
      canvas.drawCircle( // draw main seed color
        Offset(
          (seed.position.x * size.width / 15) - tileSize / 2,
          (seed.position.y * size.height / 15) - tileSize / 2
        ),
        0.8 * tileSize / 2,
        Paint()..color = seed.materialColor);
      canvas.drawCircle( // draw black outline on all seeds
        Offset(
          (seed.position.x * size.width / 15) - tileSize / 2,
          (seed.position.y * size.height / 15) - tileSize / 2
        ),
        0.8 * tileSize / 2,
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
      );
      if (seed.id == game.selectedSeedId) { // draw a special shade on the selected seed
        canvas.drawCircle(
          Offset(
            (seed.position.x * size.width / 15) - tileSize / 2,
            (seed.position.y * size.height / 15) - tileSize / 2
          ),
          0.8 * tileSize / 2,
          Paint()
            ..color = Colors.black.withOpacity(0.4)
            ..strokeWidth = 1.5
        );
      }
    }
  }
}
