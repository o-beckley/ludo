import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ludo/models/general/player.dart';
import 'package:ludo/models/ludo/ludo_game_state.dart';
import 'package:ludo/models/ludo/num_ludo_players.dart';
import 'package:ludo/models/ludo/ludo_room.dart';

class LudoService extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebasAuth = FirebaseAuth.instance;
  LudoRoom? currentRoom;

  CollectionReference<LudoRoom> get roomsReference => _firestore.collection('ludoRooms').withConverter<LudoRoom>(
    fromFirestore: (snapshot, options){
      final data = snapshot.data();
      data!.addAll({'id': snapshot.id});
      return LudoRoom.fromMap(data);
    },
    toFirestore: (value, options) {
      var v = value.toMap();
      v.remove('id');
      return v;
    }
  );

  CollectionReference<Player> get playersReference => _firestore.collection('players').withConverter<Player>(
    fromFirestore: (snapshot, options){
      var data = snapshot.data()!;
      data.addAll({'id': snapshot.id});
      return Player.fromMap(data);
    },
    toFirestore: (value, options){
      var data = value.toMap();
      data.remove('id');
      return data;
    },
  );
  
  Future<bool> createRoom({
    required NumLudoPlayers numLudoPlayers,
    required bool private,
  }) async{
    try{
      LudoRoom room = LudoRoom(
        numLudoPlayers: numLudoPlayers,
        players: [_firebasAuth.currentUser!.uid],
        private: private,
        state: RoomState.waiting,
        gameState: LudoGameState.initialGameState(numLudoPlayers)
      );
      final ref = await roomsReference.add(room);
      currentRoom = await ref.get().then((r) => r.data());
      log('room created');
      return true;
    }
    catch(e){
      log(e.toString());
      return false;
    }
  }

  Future<bool> joinPublicRoom({
    required NumLudoPlayers numLudoPlayers,
  }) async {
    int numPlayers = switch(numLudoPlayers){
      NumLudoPlayers.two => 2,
      NumLudoPlayers.four => 4
    };
    try{
      return roomsReference
      .where('private', isEqualTo:  false)
      .where('state', isEqualTo: 'waiting')
      .where('numPlayers', isEqualTo: numPlayers)
      .get()
      .then((availableRooms) async {
        if(availableRooms.docs.isNotEmpty){
          String roomId = availableRooms.docs.first.id;
          LudoRoom room = await roomsReference.doc(roomId).get().then((r) => r.data()!);
          if(!room.players.contains(_firebasAuth.currentUser!.uid)){
            // prevents joining a room more than once
            room.players.add(_firebasAuth.currentUser!.uid);
            if(room.roomFull){
              room = room.copyWith(state: RoomState.started);
            }
          }
          await roomsReference.doc(roomId).update(room.toMap());
          currentRoom = room;
          notifyListeners();
          log('room joined');
          return true;
        }
        else{ // when there is no avaialable public room
          return createRoom(numLudoPlayers: numLudoPlayers, private: false);
        }
      });
    }
    catch (e){
      log(e.toString());
      return false;
    }
  }

  Future<bool> joinPrivateRoom({
    required String roomId,
  }) async {
    try{
      LudoRoom room = await roomsReference.doc(roomId).get().then((r) => r.data()!);
      if(!room.roomFull && room.state == RoomState.waiting){
        if(!room.players.contains(_firebasAuth.currentUser!.uid)){
          // prevents joining a room more than once
          room.players.add(_firebasAuth.currentUser!.uid);
        }
        await roomsReference.doc(roomId).update(room.toMap());
        currentRoom = room;
        notifyListeners();
        return true;
      }
      else{
        log('the game is already in progress');
        return false;
      }
    }
    catch (e){
      log(e.toString());
      return false;
    }
  }

  Future<bool> leaveRoom() async { // TODO
    try{
      if (currentRoom != null){
        currentRoom = null;
        return true;
      }
      else{
        return true;
      }
    }
    catch(e){
      log(e.toString());
      return false;
    }
  }

  Future<Player?> getPlayer(String userId){
    return playersReference.doc(userId).get().then((p) => p.data()!);
  }

  Future<Stream<LudoRoom?>> getRoomSnapshots() async {
    return roomsReference
      .doc(currentRoom?.id)
      .snapshots()
      .asyncMap((data){
        currentRoom = data.data();
        return data.data();
      });
  }

  Future<bool> updateServerGameState(BuildContext context, LudoGameState newState) async {
    final currentRoom = Provider.of<LudoService>(context, listen: false).currentRoom;
    if(currentRoom != null){
      try{
        _firestore.collection('ludoRooms').doc(currentRoom.id).update({
          'gameState': newState.toMap()
        });
        return true;
      }
      catch(e){
        log(e.toString());
        return false;
      }
    }
    else{
      return false;
    }
  }
}
