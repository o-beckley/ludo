import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo/widgets/buttons.dart';
import 'package:ludo/widgets/horizontal_picker.dart';
import 'package:provider/provider.dart';
import 'package:ludo/configs/route_paths.dart';
import 'package:ludo/models/ludo/num_ludo_players.dart';
import 'package:ludo/services/ludo_service.dart';

class SelectNumPlayersScreen extends StatefulWidget {
  const SelectNumPlayersScreen({super.key});

  @override
  State<SelectNumPlayersScreen> createState() => _SelectNumPlayersScreenState();
}

class _SelectNumPlayersScreenState extends State<SelectNumPlayersScreen> {
  NumLudoPlayers selectedNumPlayers = NumLudoPlayers.two;
  bool joiningGame = false;
  @override
  Widget build(BuildContext context) {
    final ludoService = Provider.of<LudoService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HorizontalPicker(
              items: NumLudoPlayers.values.map((e) => e.name).toList(),
              onItemPicked: (index){
                selectedNumPlayers = NumLudoPlayers.values[index];
              }
            ),

            0.05.sw.verticalSpace,
            CustomOutlinedButton(
              label: 'Join game',
              disabled: joiningGame,
              onTap: () async {
                setState(() {
                  joiningGame = true;
                });
                final bool gameJoined = await ludoService.joinPublicRoom(numLudoPlayers: selectedNumPlayers);
                if(gameJoined && context.mounted){
                  GoRouter.of(context).push(RoutePaths.ludoLobbyScreen);
                }
                setState(() {
                  joiningGame = false;
                });
              },
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}

