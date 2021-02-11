import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RefreshButton extends StatelessWidget {
  final Function onPressed;
  final double iconSize;

  const RefreshButton({
    Key key,
    this.onPressed,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
        color: Colors.grey,
        iconSize: iconSize, icon: Icon(Icons.refresh_outlined), onPressed: onPressed);
  }
}
