import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:liv_farm/ui/shared/platform_widget/platform_widget.dart';

class PlatformDatePicker extends PlatformWidget {
  final DateTime initialDate;
  final Function onDateTimeChanged;

  PlatformDatePicker({this.initialDate, this.onDateTimeChanged});

  Future<DateTime> show(BuildContext context) async {
    return Platform.isIOS
        ? await showModalBottomSheet(
      backgroundColor: Colors.white,
            context: context,
            builder: (context) => this.buildCupertinoWidget(context),
          )
        : await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1910),
            lastDate: DateTime(2015));
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return Container(
      height: 300,
      child: CupertinoDatePicker(
          onDateTimeChanged: onDateTimeChanged,
          mode: CupertinoDatePickerMode.date,
          //TODO: 한국어로 만들기. 성별 만들기.
          initialDateTime: initialDate,
          minimumDate: DateTime(1910),
          maximumDate: DateTime(2015)),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    throw UnimplementedError();
  }
  
}
