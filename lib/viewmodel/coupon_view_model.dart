import 'package:flutter/material.dart';
import 'package:liv_farm/model/coupon.dart';

class CouponViewmodel with ChangeNotifier{
  List<Coupon> couponList = List();
  Coupon selectedCoupon;

  CouponViewmodel() {
    init();
  }
  init() {
    couponList.add(Coupon(
      couponID: 1,
      type: 1,
      value: 1000,
      expireDate: DateTime.now(),
      description: '첫 방문 고객님께 드리는 감사 쿠폰'
    ));
    couponList.add(Coupon(
        couponID: 2,
        type: 2,
        value: 0.1,
        expireDate: DateTime.now(),
        description: '사전 예약 신청 이벤트 쿠폰'
    ));
  }

  void selectCoupon(Coupon coupon){
    this.selectedCoupon = coupon;
    notifyListeners();
  }

}