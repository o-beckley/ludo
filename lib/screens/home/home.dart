import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ludo/configs/asset_paths.dart';
import 'package:ludo/screens/home/profile_screen.dart';
import 'package:ludo/widgets/bottom_navigation_bar.dart';

import 'home_screen.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int screenIndex = 0;
  int previousScreenIndex = 0;

  ValueNotifier<bool> bottomNavBarIsVisible = ValueNotifier(false);
  Map<String, String> iconPaths = {
    'Home': AssetPaths.homeIcon,
    'Profile': AssetPaths.profileIcon
  };
  List<Widget> screens = const [
    HomeScreen(),
    ProfileScreen(),
  ];

  static HomeState? of(BuildContext context){
    return context.findAncestorStateOfType<HomeState>();
  }

  void showPreviousScreen(){
    setState(() {
      screenIndex = previousScreenIndex;
      previousScreenIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            IndexedStack(
              index: screenIndex,
              children: screens,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(0.03.sw),
                child: CustomBottomNavBar(
                  iconPaths: iconPaths.values.toList(),
                  labels: iconPaths.keys.toList(),
                  isVisible: bottomNavBarIsVisible,
                  onTap: (value) {
                    setState(() {
                      previousScreenIndex = screenIndex;
                      screenIndex = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}