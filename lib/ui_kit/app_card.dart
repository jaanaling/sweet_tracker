import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inner_glow/inner_glow.dart';

class AppCard extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  const AppCard({
    super.key,
    required this.child,
    this.borderRadius = 17,
  });

  @override
  Widget build(BuildContext context) {
    return InnerGlow(
        width: MediaQuery.of(context).size.width - 30,
        height: 592 + 26,
        thickness: 7,
        glowRadius: borderRadius,
        strokeLinearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8BDE1), Colors.black.withOpacity(0.25)],
        ),
        baseDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Color(0xFFE2389E),
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
            width: MediaQuery.of(context).size.width - 56,
            height: 592,
            glowRadius: borderRadius - 6,
            strokeLinearGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFBD1EA), Color(0xFFda69bd)],
            ),
            baseDecoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 1,
                colors: [Color(0xFFFF95DF), Color(0xFFFFB1E7)],
              ),
              borderRadius: BorderRadius.circular(borderRadius - 6),
              boxShadow: [
                BoxShadow(
                  color: Color(0x63220052),
                  blurRadius: 6.40,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Center(child: child),
          ),
        ));
  }
}

class CardBack extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  const CardBack({
    super.key,
    required this.child,
    this.borderRadius = 17,
  });

  @override
  Widget build(BuildContext context) {
    return InnerGlow(
      width: MediaQuery.of(context).size.width - 30,
      height: 592 + 26,
      glowBlur: 4,
      glowRadius: borderRadius,
      strokeLinearGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF888CB),
          Color(0xB3BF3087)],
      ),
      baseDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: RadialGradient(
          center: Alignment.bottomCenter,
          radius: 1,
          colors: [Color(0xFFE2389E),
            Color(0xFFF45FB8)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x63220052),
            blurRadius: 6.40,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Center(child: child),
    );
  }
}
