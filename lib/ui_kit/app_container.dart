import 'package:flutter/material.dart';
import 'package:inner_glow/inner_glow.dart';

class AppContainer extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  const AppContainer({
    super.key,
    required this.child,
    required this.width,
    this.borderRadius = 17,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InnerGlow(
        width: width+20,
        height: height+20,
        glowBlur: 4,
        glowRadius: borderRadius,
        strokeLinearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFebaed3), Color(0xFFda69bd)],
        ),
        baseDecoration: BoxDecoration(
          color: Color(0xFFf193ca),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Color(0x63220052),
              blurRadius: 6.40,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Center(
          child: InnerGlow(
            glowBlur: 4,
            thickness: 7,
            width: width,
            height: height,
            glowRadius: borderRadius - 2,
            strokeLinearGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFAA3386),
                Color(0xFFBF3E99)],
            ),
            baseDecoration: BoxDecoration(
                gradient: RadialGradient(colors: [
                  Color(0xFFF16FC7),
                  Color(0xFFD043A6),
                ], radius: 1),
                borderRadius: BorderRadius.circular(borderRadius - 2)),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
