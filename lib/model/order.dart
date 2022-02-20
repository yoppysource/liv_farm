import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/my_user.dart';

class Order {
  late final String orderTitle;
  late final Address address;
  late final String storeId;
  late final int usedPoint;
  late final String id;
  late final Cart cart;
  late final DateTime? createdAt;
  late final int paidAmount;
  late final MyUser user;
  late final int status;
  late final String payMethod;
  late final String orderStatus;
  late final DateTime? scheduledDate;
  late final String? orderRequestMessage;
  late final Coupon? coupon;
  late final bool isReviewed;
  late final String? bookingOrderMessage;
  late final String option;

  Order(
      {required this.orderTitle,
      required this.address,
      required this.id,
      required this.usedPoint,
      required this.cart,
      this.createdAt,
      required this.paidAmount,
      required this.user,
      required this.storeId,
      required this.status,
      required this.payMethod,
      this.bookingOrderMessage,
      required this.scheduledDate,
      this.coupon,
      required this.orderRequestMessage,
      required this.isReviewed,
      required this.option});

  Order.fromJson(Map<String, dynamic> json) {
    orderTitle = json['orderTitle'];
    cart = Cart.fromJson(json['cart']);
    address = Address.fromJson(json['address']);
    id = json['id'];
    usedPoint = json['usedPoint'];
    createdAt = DateTime.parse(json['createdAt']);
    paidAmount = json['paidAmount'];
    bookingOrderMessage = json['bookingOrderMessage'];
    status = json['status'];
    storeId = json['storeId'];
    isReviewed = json['isReviewed'];
    payMethod = json['payMethod'];
    orderRequestMessage = json['orderRequestMessage'];
    orderStatus = json['orderStatus'];
    option = json['option'];
    if (json['scheduledDate'] != null && json['scheduledDate'] != '') {
      scheduledDate = DateTime.parse(json['scheduledDate']);
    }
  }
//유일하게 보내는 순간은 payment가 일어난 시점.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderTitle'] = orderTitle;
    data['address'] = address.toJson();
    data['cart'] = cart.id;
    data['usedPoint'] = usedPoint;
    data['_id'] = id;
    data['storeId'] = storeId;
    data['orderRequestMessage'] = orderRequestMessage;
    if (coupon != null) data['coupon'] = coupon!.toJson();
    data['paidAmount'] = paidAmount;
    data['status'] = status;
    data['user'] = user.id;
    data['option'] = option;
    data['bookingOrderMessage'] = bookingOrderMessage;
    data['payMethod'] = payMethod;
    data['createdAt'] = createdAt!.toIso8601String();
    data['scheduledDate'] =
        scheduledDate != null ? scheduledDate!.toIso8601String() : '';
    return data;
  }
}
