
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TitleText(
      {Key key,
        this.text,
        this.fontSize = 18,
        this.color = Colors.black87,
        this.fontWeight = FontWeight.w700
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(text,
          style: TextStyle(
              fontSize: fontSize, fontWeight: fontWeight, color: color,letterSpacing: 0.7)),
    );
  }
}