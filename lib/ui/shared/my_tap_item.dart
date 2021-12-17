
import 'package:flutter/material.dart';

class MyTabItem extends StatelessWidget {
  final String label;

  const MyTabItem({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(0xff333333),
              )),
    );
  }
}
