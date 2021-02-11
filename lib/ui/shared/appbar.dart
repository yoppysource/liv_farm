import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onPressed;

  const MyAppBar({Key key, this.title, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: onPressed != null ? [
        FlatButton(
          child: Text(
            '저장하기',
            style: TextStyle(fontSize: 15, color: Color(kSubColorRed)),
          ),
          onPressed: onPressed,
        ),
      ] : null,
     title: SizedBox(
       height: 40,
         width: 80,
         child: Image.asset(kLogo,color: Color(kMainColor),)),
     elevation: 0,
     backgroundColor: Colors.white,
     iconTheme: IconThemeData(color: Colors.black87),);
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
