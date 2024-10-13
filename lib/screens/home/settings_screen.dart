import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo/configs/route_paths.dart';
import 'package:ludo/services/auth_service.dart';
import 'package:ludo/utils/router_utils.dart';
import 'package:ludo/widgets/buttons.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomFilledButton(
          label: 'Sign out',
          onTap: (){
            context.read<AuthService>().signOut();
            GoRouter.of(context).clearStackAndNavigate(RoutePaths.signInScreen);
          },
        ),
      ),
    );
  }
}


