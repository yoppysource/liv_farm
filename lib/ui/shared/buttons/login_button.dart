import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String assetName;

  const LoginButton({Key key, this.onPressed, this.text, this.assetName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.065,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.black12, width: 1.0),
      ),
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
                width: MediaQuery.of(context).size.height * 0.03,
                child: Image.asset(
                  assetName,
                  fit: BoxFit.contain,
                )),
            Text(
              text,
              style: TextStyle(
                  color: Color(0xff001a33),
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.height * 0.03,
              child: Opacity(
                opacity: 0.0,
                child: Image.asset(assetName),
              ),
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
