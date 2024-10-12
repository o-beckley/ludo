import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ludo/widgets/tonal_elevation.dart';

class CustomBottomNavBar extends StatefulWidget {
  final List<String> iconPaths;
  final List<String> labels;
  final ValueNotifier<bool> isVisible;
  final ValueChanged<int>? onTap;
  final int startIndex;

  const CustomBottomNavBar({
    required this.iconPaths,
    required this.labels,
    required this.isVisible,
    this.onTap,
    this.startIndex = 0,
    super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> with SingleTickerProviderStateMixin{
  late int _currentIndex;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this
    );

    _opacityAnimation = Tween<double>(
        begin: 1,
        end: 0
    ).chain(CurveTween(curve: Curves.decelerate))
        .animate(_animationController);

    _slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(0, 1)
    ).animate(_animationController);

    widget.isVisible.addListener(() {
      if(!widget.isVisible.value){
        _animationController.forward();
      } else{
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: child
          ),
        );
      },
      child: SizedBox(
        height: 0.1.sh,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.tonalElevation(Elevation.level3, context),
            borderRadius: BorderRadius.circular(0.05.sh)
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 0.015.sh, bottom: 0.02.sh),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(widget.iconPaths.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                    widget.onTap?.call(index);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 0.0225.sh,
                        child: SvgPicture.asset(
                          widget.iconPaths[index],
                          colorFilter: index == _currentIndex
                          ? ColorFilter.mode(
                            Theme.of(context).colorScheme.inverseSurface,
                            BlendMode.srcIn
                          )
                          : ColorFilter.mode(
                            Theme.of(context).colorScheme.inverseSurface.withOpacity(0.32),
                            BlendMode.srcIn
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.labels[index],
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: index == _currentIndex
                          ? Theme.of(context).colorScheme.inverseSurface
                          : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.32)
                        ),
                      )
                    ],
                  ),
                );
              })
            ),
          ),
        ),
      )
    );
  }
}
