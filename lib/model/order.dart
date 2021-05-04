import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/my_user.dart';

class Order {
  Address address;
  String id;
  Cart cart;
  DateTime createdAt;
  int paidAmount;
  MyUser user;
  int status;
  String payMethod;
  String orderStatus;
  DateTime scheduledDate;
  String deliveryRequest;
  Coupon coupon;
  bool isReviewed;
  String deliveryReservationMessage;

  Order({
    this.address,
    this.id,
    this.cart,
    this.createdAt,
    this.paidAmount,
    this.user,
    this.status,
    this.payMethod,
    this.deliveryReservationMessage,
    this.scheduledDate,
    this.coupon,
    this.deliveryRequest,
    this.isReviewed,
  });

  Order.fromJson(Map<String, dynamic> json) {
    cart = Cart.fromJson(json['cart']) ?? null;
    address = Address.fromJson(json['address']) ?? null;
    id = json['id'];
    createdAt = DateTime.parse(json['createdAt']) ?? null;
    paidAmount = json['paidAmount'];
    deliveryReservationMessage = json['deliveryReservationMessage'];
    status = json['status'];
    isReviewed = json['isReviewed'];
    payMethod = json['payMethod'];
    deliveryRequest = json['deliveryRequest'];
    orderStatus = json['orderStatus'];
    if (json['scheduledDate'] != null && json['scheduledDate'] != '')
      scheduledDate = DateTime.parse(json['scheduledDate']) ?? null;
  }
//유일하게 보내는 순간은 payment가 일어난 시점.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address.toJson();
    data['cart'] = this.cart.id;
    data['_id'] = this.id;
    data['deliveryRequest'] = this.deliveryRequest;
    if (this.coupon != null) data['coupon'] = this.coupon.toJson();
    data['paidAmount'] = this.paidAmount;
    data['status'] = this.status;
    data['user'] = this.user.id;
    data['deliveryReservationMessage'] = this.deliveryReservationMessage;
    data['payMethod'] = this.payMethod;
    data['scheduledDate'] = this.scheduledDate?.toIso8601String() ?? '';
    return data;
  }
}
