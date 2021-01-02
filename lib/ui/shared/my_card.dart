import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child;

  const MyCard({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: child,
      color: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
    );
  }
}
