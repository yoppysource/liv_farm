import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.7,
          child: Image.asset(kLogo,
            color: Color(kMainColor),
          ),
        ),
      ),
    );
  }
}
