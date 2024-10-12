import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo/configs/route_paths.dart';
import 'package:ludo/models/ludo/num_ludo_players.dart';
import 'package:ludo/widgets/buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NumLudoPlayers selectedNumPlayers = NumLudoPlayers.two;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CustomFilledButton(
          label: 'Ludo',
          onTap: (){
            context.push(RoutePaths.selectNumPlayersScreen);
          },
        ),
      ),
    );
  }
}