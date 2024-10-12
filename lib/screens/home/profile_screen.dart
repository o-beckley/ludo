import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ludo/configs/route_paths.dart';
import 'package:ludo/services/auth_service.dart';
import 'package:ludo/widgets/custom_network_image.dart';
import 'package:ludo/widgets/buttons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(0.02.sw),
          child: RefreshIndicator(
            onRefresh: () async {
              await Provider.of<AuthService>(context, listen: false).fetchProfile();
            },
            child: ListView(
              children: [
                0.12.sw.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomIconButton(
                      iconData: Icons.edit,
                      onTap: () => context.push(RoutePaths.editProfileScreen),
                    ),
                    5.horizontalSpace,
                    CustomIconButton(
                      iconData: Icons.settings,
                      onTap: () => context.push(RoutePaths.settingsScreen),
                    ),
                  ],
                ),
                Center(
                  child: CustomNetworkImage(
                    imageUrl: auth.player?.profileImageUrl,
                    radius: 0.1.sw,
                    shape: BoxShape.circle,
                  )
                ),
                0.02.sw.verticalSpace,
                SizedBox(
                  width: 0.5.sw,
                  child: Center(
                    child: Text(
                      auth.player?.username ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                auth.player != null
                ? SizedBox(
                  width: 0.8.sw,
                  child: Center(
                    child: Text(
                      'playerId: ${auth.player!.id}',
                      style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}