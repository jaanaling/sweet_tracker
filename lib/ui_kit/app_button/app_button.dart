import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final ButtonColors color;
  final Widget widget;
  final VoidCallback? onPressed;
  final double radius;
  final double? width;
  final bool isRound;

  const AppButton({
    super.key,
    required this.color,
    required this.widget,
    this.onPressed,
    this.radius = 32,
    this.width,
    this.isRound = false,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyleConfig styleConfig = _getButtonStyleConfig(color);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      elevation: 5,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        splashColor: styleConfig.splashColor,
        child: Ink(
          width: width,
          decoration: ShapeDecoration(
            gradient: styleConfig.outerGradient,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: styleConfig.borderColor,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Ink(
              width: width,
              decoration: ShapeDecoration(
                gradient: styleConfig.innerGradient,
                shape: isRound
                    ? const OvalBorder()
                    : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              child: widget,
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyleConfig _getButtonStyleConfig(ButtonColors color) {
    switch (color) {
      case ButtonColors.pink:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFF59FF8),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFf65ccc), Color(0xFFC233C0)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF445C2), Color(0xFFC233C0)],
          ),
        );
      case ButtonColors.purple:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFc145f3),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFc145f3), Color(0xFF710096)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8C21BE), Color(0xFF710096)],
          ),
        );
      case ButtonColors.white:
        return const ButtonStyleConfig(
          splashColor: Color(0xFF9CB5DB),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFF9CB5DB)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFCDDAE8)],
          ),
        );
      case ButtonColors.grey:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFBB7FC9),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFBB7FC9)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEEEEEE), Color(0xFFD5B3E1)],
          ),
        );
      case ButtonColors.darkPurple:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFBB7FC9),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE13DC1), Color(0xFF41005F)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE13DC1), Color(0xFF8C21BE)],
          ),
        );
      default:
        // Для остальных вариантов
        return const ButtonStyleConfig(
          splashColor: Color(0xFFf86dac),
          borderColor: Color(0xFF590027),
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFf86dac), Color(0xFFad086c)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8187B), Color(0xFFC90A7F)],
          ),
        );
    }
  }
}

class ButtonStyleConfig {
  final Color splashColor;
  final Color borderColor;
  final LinearGradient outerGradient;
  final LinearGradient innerGradient;

  const ButtonStyleConfig({
    required this.splashColor,
    required this.borderColor,
    required this.outerGradient,
    required this.innerGradient,
  });
}

enum ButtonColors { pink, purple, white, grey, darkPurple}
