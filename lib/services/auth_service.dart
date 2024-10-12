import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ludo/models/general/player.dart';

class AuthService extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Player? _player;

  User? get firebaseUser => FirebaseAuth.instance.currentUser;

  Player? get player{
    if(_player == null){
      fetchProfile();
    }
    return _player;
  }

  bool get isSignedIn => _googleSignIn.currentUser != null;

  CollectionReference<Player> get playersReference => _firestore.collection('players').withConverter<Player>(
    fromFirestore: (snapshot, options){
      var data = snapshot.data()!;
      data.addAll({'id': snapshot.id});
      return Player.fromMap(data);
    },
    toFirestore: (value, options){
      var p = value.toMap();
      p.remove('id');
      return p;
    },
  );
  
  Future<bool> signInSilently() async {
    try {
      return _googleSignIn.signInSilently().then((account) => account != null);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> signIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      if (userCredential.user != null) {
        notifyListeners();
        log('signed in');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> signOut() async {
    await _googleSignIn.signOut();
    notifyListeners();
    log('signed out');
    return true;
  }

  Future<bool> get hasProfile async {
    try {
      return await _firestore
        .collection('players')
        .doc(firebaseUser!.uid)
        .get()
        .then((snapshot) => snapshot.exists);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> usernameIsAvailable(String username) async {
    try {
      return await _firestore
        .collection('players')
        .where('username', isEqualTo: username)
        .count()
        .get()
        .then((value) => value.count != null && value.count! == 0);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
  
  Future<Player?> fetchProfile() async{
    if(isSignedIn){
      _player = await playersReference.doc(firebaseUser!.uid).get().then((p) => p.data());
      notifyListeners();
      return _player;
    }
    else{
      return null;
    }
  }

  Future<bool> updateProfile({String? username, String? imagePath}) async {
    try {
      if (isSignedIn) {
        final imageRef = _storage.ref().child('profileImages/${firebaseUser!.uid}.jpg');
        String? profileImageUrl;
        if(imagePath != null){
          await imageRef.putFile(File(imagePath));
          profileImageUrl = await imageRef.getDownloadURL();
        }
        final oldProfile = await fetchProfile();
        if (oldProfile == null){
          await _firestore.collection('players').doc(firebaseUser!.uid).set({
            'username': username ?? firebaseUser?.uid,
            'profileImageUrl': profileImageUrl ?? firebaseUser?.photoURL,
          });
          log('profile updated');
          fetchProfile();
          return true;
        }
        else {
          await _firestore.collection('players').doc(firebaseUser!.uid).update({
            'username': username ?? oldProfile.username,
            'profileImageUrl': profileImageUrl ?? oldProfile.profileImageUrl,
          });
          log('profile updated');
          fetchProfile();
          return true;
        }
      }
      else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      log('something went wrong');
      return false;
    }
  }
}
