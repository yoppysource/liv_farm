// import 'package:flutter/material.dart';
// import 'package:liv_farm/ui/shared/styles.dart';

// class CustomTabIndicator extends Decoration {
//   @override
//   _CustomPainter createBoxPainter([onChanged]) {
//     return _CustomPainter(this, onChanged);
//   }
// }

// class _CustomPainter extends BoxPainter {
//   final CustomTabIndicator decoration;

//   _CustomPainter(this.decoration, VoidCallback onChanged);

//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
//     final Rect rect = offset & configuration.size!;
//     final Paint paint = Paint();
//     paint.color = kMainColor.withOpacity(0.7);
//     paint.style = PaintingStyle.fill;
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, const Radius.circular(30.0)), paint);
//   }
// }
