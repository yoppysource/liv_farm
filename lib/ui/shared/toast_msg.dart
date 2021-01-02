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

  void showPurchaseSuccessToast() {
    Fluttertoast.showToast(msg: '주문이 성공적으로 접수되었습니다.');
  }

  void showPurchaseFailToast() {
    Fluttertoast.showToast(msg: '주문이 완료되지 않았습니다.');
  }

  void showReviewSucceedToast() {
    Fluttertoast.showToast(msg: '리뷰가 등록되었습니다.');
  }
  void showReviewFailToast() {
    Fluttertoast.showToast(msg: '리뷰 등록에 실패하셨습니다.');
  }
}
