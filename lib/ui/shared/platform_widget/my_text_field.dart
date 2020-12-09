import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/platform_widget/platform_widget.dart';

class PlatformTextField extends PlatformWidget {
  final Function onChanged;
  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final TextInputType textInputType;

  PlatformTextField({this.onChanged, this.hintText, this.errorText, this.controller, this.textInputType});

//TODO: TextField dialog 분기;
  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: textInputType,
      style: Theme.of(context).textTheme.bodyText1,
      enableInteractiveSelection: false,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        counterStyle: TextStyle(
          height: double.minPositive,
        ),
        counterText: "",
        fillColor: Colors.grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: '$hintText',
        errorText: errorText,
      ),
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: textInputType,
      style: Theme.of(context).textTheme.bodyText1,
      enableInteractiveSelection: false,
      textInputAction: TextInputAction.done,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: textInputType,
      style: Theme.of(context).textTheme.bodyText1,
      enableInteractiveSelection: false,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        counterStyle: TextStyle(
          height: double.minPositive,
        ),
        counterText: "",
        fillColor: Colors.grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: '$hintText',
        errorText: errorText,
      ),
    );
  }
}
