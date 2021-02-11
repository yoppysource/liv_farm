import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/ui/shared/platform_widget/platform_widget.dart';

class PlatformTextField extends PlatformWidget {
  final Function onChanged;
  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isForDesign;
  final String text;

  PlatformTextField({this.onChanged, this.hintText, this.errorText, this.controller, this.textInputType, this.isForDesign=false, this.text = ''});

Widget build(BuildContext context) {
    return super.build(context);
  }
  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoTextField(
      readOnly:  isForDesign ? true : false,
      showCursor: isForDesign ? false : true,
      cursorColor: Color(kMainColor),
      decoration: BoxDecoration(
        color: isForDesign ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      controller: controller,
      onChanged: onChanged,
      keyboardType: textInputType,
      style: Theme.of(context).textTheme.bodyText1,
      enableInteractiveSelection: false,
      textInputAction: TextInputAction.done,
      placeholder: text,
      placeholderStyle: TextStyle(color: Colors.black87),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextField(
      readOnly:  isForDesign ? true : false,
      showCursor: isForDesign ? false : true,
      controller: controller,
      onChanged: onChanged,
      keyboardType: textInputType,
      style: Theme.of(context).textTheme.bodyText1,
      enableInteractiveSelection: false,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        filled: true,
        counterStyle: TextStyle(
          height: double.minPositive,
        ),
        counterText: "",
        fillColor: isForDesign ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
        border:
        OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: isForDesign ? text : hintText,
        hintStyle: isForDesign ? TextStyle(color: Colors.black87) : TextStyle(color: Colors.black45) ,
        errorText: errorText,
        focusColor: isForDesign ?  Colors.black : null,
        focusedBorder: isForDesign ?  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ) : null
      ),
    );
  }
}
