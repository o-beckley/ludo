import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ludo/configs/route_paths.dart';
import 'package:ludo/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController animation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).chain(CurveTween(curve: Curves.bounceOut))
    .animate(animation);
    animation.forward();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        if (await auth.signInSilently() && mounted) {
          GoRouter.of(context).pushReplacement(RoutePaths.home);
        }
        else if(mounted){
          GoRouter.of(context).pushReplacement(RoutePaths.signInScreen);
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Center(
            child: Opacity(
              opacity: animation.value,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child
              ),
            ),
          );
        },
        child: Text(
          'Ludo',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: Colors.white,
          )
        ),
      ),
    );
  }
}
