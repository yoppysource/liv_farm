import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class ToastMessageService {
  static void showToast({String message}) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.TOP,
        backgroundColor: kMainDarkGreen,
        textColor: Colors.white);
  }
}
