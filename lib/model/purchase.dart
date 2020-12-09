import 'package:liv_farm/constant.dart';

class Purchase {
  final int purchaseId;
  final int cartId;
  final int customerId;
  final String deliveryAddress;
  final int deliveryOption;
  final String orderTimestamp;
  final int purchaseStatus;

  Purchase({
    this.customerId,
    this.purchaseId,
    this.cartId,
    this.deliveryAddress,
    this.deliveryOption,
    this.orderTimestamp,
    this.purchaseStatus});

  factory Purchase.fromJson(Map<String, dynamic> data) {
    return Purchase(
        customerId: data[KEY_customer_uid],
        purchaseId: data["purchase_id"],
        cartId: data["cart_id"],
        deliveryAddress: data["delivery_address"],
        deliveryOption: data["delivery_option"],
        orderTimestamp: data["order_timestamp"],
        purchaseStatus: data['purchase_status']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      KEY_cartID: cartId,
      KEY_customer_uid: customerId,
      KEY_deliveryAddress: deliveryAddress,
      KEY_deliveryOption: deliveryOption,
      KEY_purchaseStatus: purchaseStatus,
      KEY_orderTimeStamp: orderTimestamp,
    };
  }
}
