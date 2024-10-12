import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ludo/configs/route_paths.dart';
import 'package:ludo/models/ludo/ludo_room.dart';
import 'package:ludo/models/ludo/num_ludo_players.dart';
import 'package:ludo/services/ludo_service.dart';
import 'package:ludo/widgets/custom_network_image.dart';

class LudoLobbyScreen extends StatefulWidget {
  const LudoLobbyScreen({super.key});

  @override
  State<LudoLobbyScreen> createState() => _LudoLobbyScreenState();
}

class _LudoLobbyScreenState extends State<LudoLobbyScreen> {
  Future<Stream<LudoRoom?>>? roomSnapshots;
  late StreamSubscription<LudoRoom?> roomSubscription;
  @override
  void initState(){
    super.initState();
    final ludoService = Provider.of<LudoService>(context, listen: false);
    if(ludoService.currentRoom != null && ludoService.currentRoom?.id != null){
      roomSnapshots = ludoService.getRoomSnapshots();
    }
    else{
      log('something went wrong while getting room snapshots');
    }
    roomSnapshots?.then((snapshots){
      roomSubscription = snapshots.listen((room) async {
        if(room != null){
          final numplayers = room.numLudoPlayers == NumLudoPlayers.two ? 2 : 4;
          if(numplayers == room.players.length){
            if(ludoService.currentRoom != null && mounted){
              GoRouter.of(context).pushReplacement(RoutePaths.ludoGameScreen);
            }
          }
        }
      });
    });
  }

  @override
  void dispose(){
    roomSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ludoService = Provider.of<LudoService>(context);
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FutureBuilder(
              future: ludoService.getRoomSnapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data != null){
                  return StreamBuilder(
                    stream: snapshot.data,
                    builder: (context, snapshot) {
                      if(snapshot.hasData && snapshot.data != null){
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data!.id ?? ''),
                            Text('${snapshot.data!.players.length} / ${snapshot.data!.numLudoPlayers == NumLudoPlayers.two ? 2 : 4}')
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }
                  );
                }
                return const SizedBox.shrink();
              }
            ),
          ),

          Center(
            child: FutureBuilder(
              future: ludoService.getRoomSnapshots(),
              builder: (context, snapshot){
                if (snapshot.hasData && snapshot.data != null){
                  return StreamBuilder(
                    stream: snapshot.data,
                    builder: (context, snapshot){
                      //TODO: return custom painter on each snapshot
                      if(snapshot.hasData && snapshot.data != null){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            snapshot.data!.players.length,
                            (index){
                              return FutureBuilder(
                                future: ludoService.getPlayer(snapshot.data!.players[index]),
                                builder: (context, snapshot){
                                  if(snapshot.hasData && snapshot.data != null){
                                    return Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(snapshot.data!.username),
                                          CustomNetworkImage(
                                            imageUrl: snapshot.data!.profileImageUrl,
                                            radius: 35,
                                            shape: BoxShape.circle,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }
                              );
                            }
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                }
                return const SizedBox.square(
                  dimension: 50,
                  child: CircularProgressIndicator(),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}