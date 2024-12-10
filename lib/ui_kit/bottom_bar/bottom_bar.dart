import 'package:flutter/material.dart';
import 'package:inner_glow/inner_glow.dart';

import '../../src/core/utils/app_icon.dart';
import '../../src/core/utils/icon_provider.dart';

import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final Function(int) onTap;
  const BottomBar({super.key, required this.onTap});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<String> icons = [
    IconProvider.home.buildImageUrl(),
    IconProvider.catalog.buildImageUrl(),
    IconProvider.diary.buildImageUrl(),
  ];

  late AnimationController _animationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    // Контроллер для анимации масштабирования и других эффектов
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return InnerGlow(
      width: MediaQuery.of(context).size.width - 30,
      height: 80,
      baseDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA701AA), Color(0xFF950098)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      glowRadius: 25,
      strokeLinearGradient: LinearGradient( end: Alignment.bottomCenter, begin: Alignment.topCenter,
          colors: [Color(0xFFF59FF8), Colors.black.withOpacity(0.25)]),
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ...List.generate(icons.length, (index) {
            bool isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  widget.onTap(index);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Добавляем свечение только для выбранного элемента
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: isSelected
                                ? Color(0xFFDF0EB7).withOpacity(0.5)
                                : Colors.transparent,
                            spreadRadius: 8,
                            blurRadius: 11,
                          )
                        ]
                      : [],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                          begin: 1.0, end: isSelected ? 1.2 : 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: AppIcon(
                        asset: icons[index],
                        width: 28,
                        height: 28,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                  widget.onTap(3);
                });
              },
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Добавляем свечение только для выбранного элемента
                    boxShadow: _selectedIndex == 3
                        ? [
                            BoxShadow(
                              color: _selectedIndex == 3
                                  ? Color(0xFFDF0EB7).withOpacity(0.5)
                                  : Colors.transparent,
                              spreadRadius: 8,
                              blurRadius: 11,
                            )
                          ]
                        : [],
                  ),
                  child: Stack(alignment: Alignment.center, children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                          begin: 1.0, end: _selectedIndex == 3 ? 1.2 : 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: Icon(
                        Icons.shuffle,
                        size: 35,
                        color: _selectedIndex == 3
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ])))
        ]),
      ),
    );
  }
}
