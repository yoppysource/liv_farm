import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/my_user.dart';

class Order {
  String orderTitle;
  Address address;
  String storeId;
  int usedPoint;
  String id;
  Cart cart;
  DateTime createdAt;
  int paidAmount;
  MyUser user;
  int status;
  String payMethod;
  String orderStatus;
  DateTime scheduledDate;
  String orderRequestMessage;
  Coupon coupon;
  bool isReviewed;
  String bookingOrderMessage;
  String option;

  Order(
      {this.orderTitle,
      this.address,
      this.id,
      this.usedPoint,
      this.cart,
      this.createdAt,
      this.paidAmount,
      this.user,
      this.storeId,
      this.status,
      this.payMethod,
      this.bookingOrderMessage,
      this.scheduledDate,
      this.coupon,
      this.orderRequestMessage,
      this.isReviewed,
      this.option});

  Order.fromJson(Map<String, dynamic> json) {
    orderTitle = json['orderTitle'] ?? null;
    cart = Cart.fromJson(json['cart']) ?? null;
    address = Address.fromJson(json['address']) ?? null;
    id = json['id'];
    usedPoint = json['usedPoint'];
    createdAt = DateTime.parse(json['createdAt']) ?? null;
    paidAmount = json['paidAmount'];
    bookingOrderMessage = json['bookingOrderMessage'];
    status = json['status'];
    storeId = json['storeId'];
    isReviewed = json['isReviewed'];
    payMethod = json['payMethod'];
    orderRequestMessage = json['orderRequestMessage'];
    orderStatus = json['orderStatus'];
    option = json['option'];
    if (json['scheduledDate'] != null && json['scheduledDate'] != '')
      scheduledDate = DateTime.parse(json['scheduledDate']) ?? null;
  }
//유일하게 보내는 순간은 payment가 일어난 시점.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderTitle'] = this.orderTitle ?? '';
    data['address'] = this.address.toJson();
    data['cart'] = this.cart.id;
    data['usedPoint'] = this.usedPoint;
    data['_id'] = this.id;
    data['storeId'] = this.storeId;
    data['orderRequestMessage'] = this.orderRequestMessage;
    if (this.coupon != null) data['coupon'] = this.coupon.toJson();
    data['paidAmount'] = this.paidAmount;
    data['status'] = this.status;
    data['user'] = this.user.id;
    data['option'] = this.option;
    data['bookingOrderMessage'] = this.bookingOrderMessage;
    data['payMethod'] = this.payMethod;
    data['createdAt'] = this.createdAt.toIso8601String();
    data['scheduledDate'] = this.scheduledDate?.toIso8601String() ?? '';
    return data;
  }
}
