import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../src/core/utils/icon_provider.dart';
import '../ui_kit/bottom_bar/bottom_bar.dart';

class RootNavigationScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RootNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<RootNavigationScreen> createState() => _RootNavigationScreenState();
}

class _RootNavigationScreenState extends State<RootNavigationScreen> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFFFFB6FD)),
            ),
          ),
          widget.navigationShell,
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              child: BottomBar(
                onTap: _onTap,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onTap(int index) {
    int cIndex = 0;

    switch (index) {
      case 0:
        cIndex = 0;
      case 1:
        cIndex = 1;
      case 2:
        cIndex = 2;
      case 3:
        cIndex = 3;
      default:
    }

    widget.navigationShell.goBranch(
      cIndex,
      initialLocation: true,
    );
  }
}
