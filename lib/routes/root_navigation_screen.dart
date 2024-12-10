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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                 IconProvider.background.buildImageUrl()
             
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          widget.navigationShell,
          Positioned(
              bottom: 5 + MediaQuery.of(context).padding.bottom,
              left: 10,
              right: 10,
              child: BottomBar(
                onTap: _onTap,
              ))
        ],
      ),
    );
  }

  void _onTap(int index) {
    int cIndex = 0;

    switch (index) {
      case 0:
        cIndex = 1;
      case 1:
        cIndex = 0;
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

    setState(() {
      _currentIndex = index;
    });
  }
}
