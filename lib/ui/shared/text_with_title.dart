import 'package:flutter/material.dart';

class TextWithTitle extends StatelessWidget {
  final String title;
  final String text;

  const TextWithTitle({Key key, this.title, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.black.withOpacity(0.6)),),
          SizedBox(height: 2,),
          Text(text, style: TextStyle(color: Colors.black87,),),
        ],
      ),
    );
  }
}
