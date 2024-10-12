import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ludo/services/auth_service.dart';
import 'package:ludo/services/ludo_service.dart';
import 'package:provider/provider.dart';
import 'package:ludo/configs/router_config.dart';
import 'package:ludo/theme/color_theme.dart';
import 'package:ludo/theme/theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LudoApp());
}

class LudoApp extends StatelessWidget {
  const LudoApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return MultiProvider(
      providers: [
        ListenableProvider<UIColors>(create: (context) => UIColors()),
        ListenableProvider<AuthService>(create: (context) => AuthService()),
        ListenableProvider<LudoService>(create: (context) => LudoService()),
      ],
      child: const Ludo(),
    );
  }
}


class Ludo extends StatefulWidget {
  const Ludo({super.key});

  @override
  State<Ludo> createState() => _LudoState();
}

class _LudoState extends State<Ludo> with WidgetsBindingObserver{
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      final uiColors = context.read<UIColors>();
      final brightness = PlatformDispatcher.instance.platformBrightness;
      uiColors.darkMode.value = brightness == Brightness.dark;
    });
  }

  @override
  void didChangePlatformBrightness() {
    final uiColors = context.read<UIColors>();
    final brightness = PlatformDispatcher.instance.platformBrightness;
    uiColors.darkMode.value = brightness == Brightness.dark;
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ludo',
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: routerConfig,
    );
  }
}
