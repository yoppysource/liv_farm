import 'package:flutter/material.dart';

class MyTabItem extends StatelessWidget {
  final String label;

  const MyTabItem({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: const Color(0xff333333),
              )),
    );
  }
}
