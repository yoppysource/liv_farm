import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RefreshButton extends StatelessWidget {
  final Function onPressed;

  const RefreshButton({Key key,@required this.onPressed,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: MediaQuery.of(context).size.height/10,
        icon: Icon(Icons.refresh), onPressed: onPressed);
  }
}
