import 'package:flutter/material.dart';

class InAppButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final Color buttonColor;

  InAppButton(
      {@required this.onPressed,
      @required this.child,
      @required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: child,
        onPressed:
          onPressed,

      ),
      decoration: BoxDecoration(
        color: buttonColor,
        boxShadow: [
          BoxShadow(
              offset: Offset(2, 3),
              blurRadius: 1.0,
              color: Colors.grey.withOpacity(0.5))
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
