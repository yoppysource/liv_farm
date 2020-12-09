import 'package:flutter/material.dart';

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
            style: TextStyle(fontSize: 15, color: Colors.blue),
          ),
          onPressed: onPressed,
        ),
      ] : null,
     title: Text(title,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
     elevation: 0,
     backgroundColor: Theme
         .of(context)
         .scaffoldBackgroundColor,
     iconTheme: IconThemeData(color: Colors.black87),);
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
