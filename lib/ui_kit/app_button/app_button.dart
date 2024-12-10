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
    this.isRound = false
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyleConfig styleConfig = _getButtonStyleConfig(color);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        splashColor: styleConfig.splashColor,
        child: Padding(
          padding: const EdgeInsets.all(2),
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
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
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
            colors: [Color(0xFFF59FF8),
              Color(0xFFAA3386)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF371CC),
              Color(0xFFFF41A9)],
          ),
        );
      case ButtonColors.yellow:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFF6BD6D),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6BD6D), Color(0xFF985C06)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF9E17), Color(0xFFCD7C00)],
          ),
        );
      case ButtonColors.grey:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFA8A8A8),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA8A8A8), Color(0xFF535353)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7D7D7D), Color(0xFF676767)],
          ),
        );
      case ButtonColors.red:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFfb6d6d),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFfb6d6d), Color(0xFFa20707)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF3217), Color(0xFFC40808)],
          ),
        );
      case ButtonColors.purple:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFAD3FED),
          borderColor: Color(0xFFF549FF),
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFAD3FED),
              Color(0xFF3C0E51)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF611883),
              Color(0xFF4F027A)],
          ),
        );
      case ButtonColors.orange:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFF3A487),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3A487),
              Color(0xFF5C2816)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE17A54),
              Color(0xFFE66738)],
          ),
        );
      case ButtonColors.white:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFCACACA),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFCACACA),
              Color(0xFF515151)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF),
              Color(0xFFC6C6C6)],
          ),
        );
      case ButtonColors.darkOrange:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFE3805A),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3805A),
              Color(0xFF531903)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA03914),
              Color(0xFF9E2E03)],
          ),
        );
      case ButtonColors.green:
        return const ButtonStyleConfig(
          splashColor: Color(0xFF8DF694),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8DF694),
              Color(0xFF006505)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF30D53B),
              Color(0xFF008310)],
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

enum ButtonColors { pink, yellow, grey, purple, red, white, darkOrange, orange, green }
