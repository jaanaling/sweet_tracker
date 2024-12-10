import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:inner_glow/inner_glow.dart';
import 'package:sweet_planner/src/core/utils/size_utils.dart';

import '../../src/core/utils/app_icon.dart';
import '../../src/core/utils/icon_provider.dart';

import 'package:flutter/material.dart';

List<String> iconPathsUnselected = [
  IconProvider.home.buildImageUrl(),
  IconProvider.shop.buildImageUrl(),
  IconProvider.history.buildImageUrl(),
  IconProvider.accept.buildImageUrl(),
];

List<String> iconPathsSelected = [
  IconProvider.home_a.buildImageUrl(),
  IconProvider.shop_a.buildImageUrl(),
  IconProvider.history_a.buildImageUrl(),
  IconProvider.accept_a.buildImageUrl(),
];

class BottomBar extends StatefulWidget {
  final Function(int) onTap;
  const BottomBar({super.key, required this.onTap});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            unselectedItem(iconPathsUnselected[0], true, false, () {
              setState(() {
                _selectedIndex = 0;
              });
              widget.onTap(0);
            }),
            unselectedItem(iconPathsUnselected[1], false, false, () {
              setState(() {
                _selectedIndex = 1;
              });
              widget.onTap(1);
            }),
            unselectedItem(iconPathsUnselected[2], false, false, () {
              setState(() {
                _selectedIndex = 2;
              });
              widget.onTap(2);
            }),
            unselectedItem(iconPathsUnselected[3], false, true, () {
              setState(() {
                _selectedIndex = 3;
              });
              widget.onTap(3);
            }),
          ],
        ),

        // Для первого элемента
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: 0,
          top: 0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                child: child,
              );
            },
            child: _selectedIndex == 0
                ? selectedItem(iconPathsSelected[0], 'HOME', null, true, false, () {
              setState(() {
                _selectedIndex = 0;
              });
              widget.onTap(0);
            }, 22)
                : const SizedBox(),
          ),
        ),

        // Для второго элемента
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: getWidth(0.2, context) - 2,
          top: 0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                child: child,
              );
            },
            child: _selectedIndex == 1
                ? selectedItem(iconPathsSelected[1], 'SHOPPING LIST', null, false, false, () {
              setState(() {
                _selectedIndex = 1;
              });
              widget.onTap(1);
            }, null)
                : const SizedBox(),
          ),
        ),

        // Для третьего элемента
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: (getWidth(0.2, context) - 2)*2,
          top: 0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                child: child,
              );
            },
            child: _selectedIndex == 2
                ? selectedItem(iconPathsSelected[2], 'HISTORY', null, false, false, () {
              setState(() {
                _selectedIndex = 2;
              });
              widget.onTap(2);
            }, 17)
                : const SizedBox(),
          ),
        ),

        // Для четвертого элемента
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: (getWidth(0.2, context) - 2)*3,
          top: 0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                child: child,
              );
            },
            child: _selectedIndex == 3
                ? selectedItem(iconPathsSelected[3], 'Usage', 'confirmation', false, true, () {
              setState(() {
                _selectedIndex = 3;
              });
              widget.onTap(3);
            }, null)
                : const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget selectedItem(String iconPath, String label, String? secondLabel,
      bool isLeft, bool isRight, void Function() onTap, double? fontSize) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7, right: 5, left: 7, top: 3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: isLeft ? Radius.circular(10) : Radius.zero,
            bottomRight: isRight ? Radius.circular(10) : Radius.zero,
          ),
          splashColor: Color(0xFFF67BD0),
          child: Ink(
            width: getWidth(0.2, context) - 4,
            height: 89,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFFF445C2), Color(0xFFC233C0)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: isLeft ? Radius.circular(10) : Radius.zero,
                  bottomRight: isRight ? Radius.circular(10) : Radius.zero,
                ),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x8E220037),
                  blurRadius: 6.10,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(asset: iconPath),
                  Gap(8),
                  if (secondLabel == null)
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:fontSize?? 15,
                        fontFamily: 'Boleh',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  else
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'USAGE\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Boleh',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'CONFIRMATION',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Boleh',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget unselectedItem(
      String iconPath, bool isLeft, bool isRight, void Function() onTap) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 7,
        right: isRight?7:0,
        left: isLeft?7:0
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.only(
            topLeft: isLeft ? Radius.circular(15) : Radius.zero,
            topRight: isRight ? Radius.circular(15) : Radius.zero,
            bottomLeft: isLeft ? Radius.circular(15) : Radius.zero,
            bottomRight: isRight ? Radius.circular(15) : Radius.zero,
          ),
          splashColor: Color(0xFFc145f3),
          child: Ink(
            decoration: BoxDecoration(
              color: Color(0xFFc145f3),
              borderRadius: BorderRadius.only(
                topLeft: isLeft ? Radius.circular(15) : Radius.zero,
                topRight: isRight ? Radius.circular(15) : Radius.zero,
                bottomLeft: isLeft ? Radius.circular(15) : Radius.zero,
                bottomRight: isRight ? Radius.circular(15) : Radius.zero,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLeft)
                    SizedBox(
                      height: 75,
                      child: VerticalDivider(
                        color: Color(0xFF610880),
                        width: 2,
                      ),
                    ),
                  Ink(
                    width: getWidth(0.2, context) - 4,
                    height: 75,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFF8C21BE), Color(0xFF710096)],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: isLeft ? Radius.circular(15) : Radius.zero,
                        topRight: isRight ? Radius.circular(15) : Radius.zero,
                        bottomLeft: isLeft ? Radius.circular(15) : Radius.zero,
                        bottomRight:
                            isRight ? Radius.circular(15) : Radius.zero,
                      ),
                    ),
                    child: Center(
                      child: AppIcon(asset: iconPath),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
