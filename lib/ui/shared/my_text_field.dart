import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final TextInputAction textInputAction;
  final VoidCallback onEditingComplete;

  const MyTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    required this.onEditingComplete,
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
          borderSide: const BorderSide(color: Colors.black45),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
    );
  }
}
