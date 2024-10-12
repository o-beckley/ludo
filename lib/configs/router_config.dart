import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo/configs/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:ludo/screens/authentication/set_profile_screen.dart';
import 'package:ludo/screens/authentication/sign_in_screen.dart';
import 'package:ludo/screens/authentication/splash_screen.dart';
import 'package:ludo/screens/home/edit_profile_screen.dart';
import 'package:ludo/screens/home/home.dart';
import 'package:ludo/screens/home/settings_screen.dart';
import 'package:ludo/screens/ludo/ludo_game_screen.dart';
import 'package:ludo/screens/ludo/ludo_lobby_screen.dart';
import 'package:ludo/screens/ludo/select_num_players_screen.dart';

final GoRouter routerConfig = GoRouter(
  initialLocation: RoutePaths.splashScreen,
  errorBuilder: (context, state) => const ErrorBuilder(),
  routes: [
    GoRoute(
      path: RoutePaths.editProfileScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const EditProfileScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.home,
      pageBuilder: (context, state) => CupertinoPage(
        child: const Home(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.ludoGameScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const LudoGameScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.ludoLobbyScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const LudoLobbyScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.selectNumPlayersScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SelectNumPlayersScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.setProfileScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SetProfileScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.settingsScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SettingsScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.signInScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SignInScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.splashScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SplashScreen(),
        key: state.pageKey
      )
    ),
  ]
);

class ErrorBuilder extends StatelessWidget {
  final String? message;
  const ErrorBuilder({
    this.message,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message ?? 'Navigation error has occurred',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.error
          ),
        ),
      ),
    );
  }
}