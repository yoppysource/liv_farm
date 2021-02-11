import 'package:flutter/cupertino.dart';

class Coupon {
  final int couponID;
  final int type;
  final double value;
  final DateTime expireDate;
  final String description;

  Coupon({@required this.couponID,@required this.type,@required this.value,@required this.expireDate, @required this.description});

  factory Coupon.fromJson({Map<String, dynamic> data}){
    if(data ==null){
      return null;
    }
    return Coupon(couponID: data['coupon_id'], type: data['type'], value: data['value'], expireDate: data['expire_date']);
  }

  Map<String, dynamic> toJson(Coupon coupon) {
    return {
      'coupon_id': coupon.couponID,
      'type' : coupon.type,
      'value' : coupon.value,
      'expire_date' : coupon.expireDate,
      'description' : coupon.description,
    };
  }
}