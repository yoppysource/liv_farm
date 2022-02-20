import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bubbleSize = Size(size.width, size.height * 0.8);
    final tailSize = Size(size.width * 0.1, size.height - bubbleSize.height);
    final fillet = bubbleSize.width * 0.1;
    final tailStartPoint = Point(size.width * 0.7, bubbleSize.height);
    //bubble body
    final bubblePath = Path()
      ..moveTo(0, fillet)
      // 왼쪽 위에서 왼쪽 아래 라인
      ..lineTo(0, bubbleSize.height - fillet)
      ..quadraticBezierTo(0, bubbleSize.height, fillet, bubbleSize.height)
      // 왼쪽 아래에서 오른쪽 아래 라인
      ..lineTo(bubbleSize.width - fillet, bubbleSize.height)
      ..quadraticBezierTo(bubbleSize.width, bubbleSize.height, bubbleSize.width,
          bubbleSize.height - fillet)
      // 오른쪽 아래에서 오른쪽 위 라인
      ..lineTo(bubbleSize.width, fillet)
      ..quadraticBezierTo(bubbleSize.width, 0, bubbleSize.width - fillet, 0)
      // 오른쪽 위에서 왼쪽 아래 라인
      ..lineTo(fillet, 0)
      ..quadraticBezierTo(0, 0, 0, fillet);
    // bubble tail
    final tailPath = Path()
      ..moveTo(tailStartPoint.x, tailStartPoint.y)
      ..cubicTo(
        tailStartPoint.x + (tailSize.width * 0.2),
        tailStartPoint.y,
        tailStartPoint.x + (tailSize.width * 0.6),
        tailStartPoint.y + (tailSize.height * 0.2),
        tailStartPoint.x + tailSize.width / 2, // 목적지 x
        tailStartPoint.y + tailSize.height, // 목적지 y
      )
      ..cubicTo(
        (tailStartPoint.x + tailSize.width / 2) + (tailSize.width * 0.2),
        tailStartPoint.y + tailSize.height,
        tailStartPoint.x + tailSize.width,
        tailStartPoint.y + (tailSize.height * 0.3),
        tailStartPoint.x + tailSize.width, // 목적지 x
        tailStartPoint.y, // 목적지 y
      );
    // add tail to bubble body
    bubblePath.addPath(tailPath, const Offset(0, 0));
    // paint setting
    final paint = Paint()
      ..color = kDelightPink.withOpacity(0.9)
      ..style = PaintingStyle.stroke;
    // draw
    canvas.drawPath(bubblePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
