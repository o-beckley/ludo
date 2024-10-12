import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ludo/theme/color_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalPicker extends StatefulWidget {
  final List<String> items;
  final Function(int)? onItemPicked;
  final int startingIndex;
  final double endPadding;

  const HorizontalPicker({
    required this.items,
    this.onItemPicked,
    this.startingIndex = 0,
    this.endPadding = 0,
    super.key
  });

  @override
  State<HorizontalPicker> createState() => _HorizontalPickerState();
}

class _HorizontalPickerState extends State<HorizontalPicker> {
  late int selectedIndex;

  @override
  void initState(){
    super.initState();
    selectedIndex = widget.startingIndex;
  }

  @override
  Widget build(BuildContext context) {
    double radius = math.max(20, 50 / widget.items.length);
    return SizedBox(
      height: 2 * radius,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            widget.items.length,
            (index){
              return  Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? widget.endPadding : radius / 2,
                  right: index + 1 == widget.items.length ? widget.endPadding : 0
                ),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onItemPicked?.call(index);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          /// This 0.9 comes from the fact that the main screens
                          ///  where this is used has a 0.05 padding on both sides
                          /// 1 - 2 * 0.05 = 0.9
                          /// and the radius / 2 comes from the inner paddings
                          /// above the consequence of this is that it centralizes
                          /// the contents when there are only few items,
                          /// say 2 or 3 😉
                          /// ... no one is gonna read this tho 😐
                          minWidth: (0.9.sw / widget.items.length) - radius / 2
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          color: index == selectedIndex
                          ? context.watch<UIColors>().primary
                          : context.watch<UIColors>().surfaceContainer
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: radius),
                          child: Center(
                            child: Text(
                              widget.items[index],
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: index == selectedIndex
                                ? context.watch<UIColors>().onPrimaryContainer
                                : context.watch<UIColors>().onSurface
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
