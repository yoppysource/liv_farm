import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'platform_widget.dart';

class PlatformDatePicker extends PlatformWidget {
  final DateTime initialDate;
  final Function onDateTimeChanged;

  const PlatformDatePicker(
      {Key? key, required this.initialDate, required this.onDateTimeChanged})
      : super(key: key);

  Future<DateTime> show(BuildContext context) async {
    return Platform.isIOS
        ? await showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            builder: (context) => buildCupertinoWidget(context),
          )
        : await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1910),
            confirmText: '선택',
            cancelText: '취소',
            lastDate: DateTime(2015));
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    late DateTime selectedDateTime;
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: 50,
              child: CupertinoButton(
                child: const Text('선택'),
                onPressed: () => Navigator.of(context).pop(selectedDateTime),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
                onDateTimeChanged: (DateTime dateTime) {
                  selectedDateTime = dateTime;
                },
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate,
                minimumDate: DateTime(1910),
                maximumDate: DateTime(2015)),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    throw UnimplementedError();
  }
}
