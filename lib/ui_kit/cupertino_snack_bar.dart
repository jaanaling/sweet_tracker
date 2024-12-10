import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCupertinoSnackBar(BuildContext context, String massage) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 100.0,
      left: MediaQuery.of(context).size.width * 0.1,
      child: _CupertinoSnackBar(
        message: massage,
        duration: const Duration(milliseconds: 3500),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

class _CupertinoSnackBar extends StatelessWidget {
  final String message;
  final Duration duration;

  const _CupertinoSnackBar({
    required this.message,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}