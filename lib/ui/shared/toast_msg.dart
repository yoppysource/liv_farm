import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  void showErrorToast() {
    Fluttertoast.showToast(msg: '오류가 발생 했습니다. 잠시 후에 다시 시도해 주세요.');
  }

  void showCartSuccessToast() {
    Fluttertoast.showToast(msg: '장바구니에 성공적으로 담겼습니다');
  }
  void showInfoSuccessToast() {
    Fluttertoast.showToast(msg: '유저 정보가 변경되었습니다.');
  }
}
