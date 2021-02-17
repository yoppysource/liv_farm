import 'package:flutter/material.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/repository/coupon_repository.dart';

class CouponViewmodel with ChangeNotifier{
  List<Coupon> couponList = List();
  Coupon selectedCoupon;
  CouponRepository _repository = CouponRepository();

  CouponViewmodel(int customerID) {
    Future.microtask(() async=> await init(customerID));
  }
  Future<void> init(customerID) async{
    couponList = await _repository.getCustomerCoupon(customerID);
    print(couponList[0]);
    notifyListeners();
  }

  void selectCoupon(Coupon coupon){
    this.selectedCoupon = coupon;
    notifyListeners();
  }

  Future<bool> registerCoupon(int customerID, String input) async {
    bool result=await _repository.registerCoupon(customerID, input);
    return result;
  }

}