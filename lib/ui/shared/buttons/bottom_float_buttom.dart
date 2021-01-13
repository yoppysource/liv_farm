import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';

class BottomFloatButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const BottomFloatButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: FlatButton(
          disabledColor: Colors.grey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          color: Color(kSubColorRed).withOpacity(0.9),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}