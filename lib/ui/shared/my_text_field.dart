import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final TextInputAction textInputAction;
  final VoidCallback onEditingComplete;

  const MyTextField({
    Key key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black45),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
    );
  }
}
