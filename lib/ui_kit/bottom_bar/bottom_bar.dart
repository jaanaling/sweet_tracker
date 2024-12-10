import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:inner_glow/inner_glow.dart';
import 'package:sweet_planner/src/core/utils/size_utils.dart';

import '../../src/core/utils/app_icon.dart';
import '../../src/core/utils/icon_provider.dart';

import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final Function(int) onTap;
  const BottomBar({super.key, required this.onTap});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [],
    );
  }

  Widget selectedItem(String iconPath, String label) {
    return Container(
      width: getWidth(0.2, context),
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
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Boleh',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget unselectedItem(String iconPath, String label) {
    return Container(
      width: getWidth(0.2, context),
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
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Boleh',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
