import 'dart:async';

import 'package:advertising_id/advertising_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

import 'package:go_router/go_router.dart';
import '../../../../../routes/route_value.dart';
import '../../../../core/utils/app_icon.dart';
import '../../../../core/utils/icon_provider.dart';
import '../../../../core/utils/size_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    startLoading(context);
  }

  Future<void> startLoading(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final adId = await AdvertisingId.id(true);
    context.go(RouteValue.home.path);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: AppIcon(
            asset: IconProvider.splash.buildImageUrl(),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: height * 0.175,
          child: AppIcon(
            asset: IconProvider.logo.buildImageUrl(),
            width: 333,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
            bottom: height * 0.075,
            child: Column(
              children: [
                SizedBox(
                    width: 72, height: 72, child: CupertinoActivityIndicator(color: Colors.white,)),
                Gap(22),
                LoadingAnimation()
              ],
            )),
      ],
    );
  }
}

class LoadingAnimation extends StatefulWidget {
  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();

    _animation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.6)),
    );

    _animation2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.2, 0.8)),
    );

    _animation3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.4, 1.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'loading',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        Gap(3),
        AnimatedDot(animation: _animation1),
        SizedBox(width: 8),
        AnimatedDot(animation: _animation2),
        SizedBox(width: 8),
        AnimatedDot(animation: _animation3),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedDot extends StatelessWidget {
  final Animation<double> animation;

  AnimatedDot({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            opacity: animation.value,
            child: Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}
