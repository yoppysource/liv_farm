import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child;

  const MyCard({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Card(
        child: child,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
