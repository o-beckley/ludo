import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ludo/configs/asset_paths.dart';
import 'package:ludo/configs/route_paths.dart';
import 'package:ludo/services/auth_service.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: design SignInScreen
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              auth.signIn().then((signedIn) async {
                if (signedIn) {
                  if (await auth.hasProfile && context.mounted) {
                    GoRouter.of(context)
                        .pushReplacement(RoutePaths.home);
                  } else if (context.mounted) {
                    GoRouter.of(context)
                        .pushReplacement(RoutePaths.setProfileScreen);
                  }
                }
              });
            },
            child: SizedBox(
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 24),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                          dimension: 18,
                          child: SvgPicture.asset(AssetPaths.googleIcon)),
                      8.horizontalSpace,
                      Text(
                        'sign in with google',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          20.verticalSpace,
        ],
      ),
    ));
  }
}
