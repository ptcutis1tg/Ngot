import 'package:flutter/material.dart';

extension FloatingOverlayExtension on Widget {
  OverlayEntry showFloatingOverlay(BuildContext context,
      {double? height, double? width}) {
    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => overlayEntry.remove(),
              child: Container(color: Colors.black38), // Nền mờ, bấm để tắt
            ),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                height: height,
                width: width,
                child: this,
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(overlayEntry);
    return overlayEntry;
  }

  void hideFloatingOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    overlay.dispose();
  }
}
