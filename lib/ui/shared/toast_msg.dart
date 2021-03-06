
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {

  void msg(String msg) {
    Fluttertoast.showToast(msg: msg);
  }
  void showErrorToast() {
    Fluttertoast.showToast(msg: '오류가 발생 했습니다. 잠시 후에 다시 시도해 주세요.');
  }

  void showCouponSuccessToast() {
    Fluttertoast.showToast(msg: '쿠폰이 성공적으로 등록되었습니다.');
  }

  void showCouponFailToast() {
    Fluttertoast.showToast(msg: '존재하지 않는 번호거나 이미 등록한 쿠폰입니다.');
  }


  void showCartSuccessToast() {
    Fluttertoast.showToast(msg: '장바구니에 성공적으로 담겼습니다');
  }
  void showCartAddQuantityToast() {
    Fluttertoast.showToast(msg: '이미 담긴 상품에 수량을 추가하셨습니다.');
  }
  void showInventoryErrorToast() {
    Fluttertoast.showToast(msg: '재고가 부족합니다.');
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

  void showPurchaseFailByInventoryToast() {
    Fluttertoast.showToast(msg: '재고보다 상품수량이 더 많습니다.');
  }
  void showPaidButNotUploaded() {
    Fluttertoast.showToast(msg: '죄송합니다. 내부 에러가 발생했습니다. 고객센터에 연락 바랍니다.');
  }

  void showReviewSucceedToast() {
    Fluttertoast.showToast(msg: '리뷰가 등록되었습니다.');
  }
  void showReviewFailToast() {
    Fluttertoast.showToast(msg: '리뷰 등록에 실패하셨습니다.');
  }

  void showSystemBackButtonPressed() {
    Fluttertoast.showToast(msg: '앱을 종료하실려면 한번 더 눌러주세요.');
  }
}
