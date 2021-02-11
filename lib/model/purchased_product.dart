class PurchasedProduct {
  final String orderTimestamp;
  final int purchasedStatus;
  final int productId;
  final int quantity;

  static Map<int, String> purchasedStatusMap = {
    0: '결제완료',
    1: '포장 중',
    2: '배송 중',
    3: '전달 완료',
    4: '환불 처리',
  };

  PurchasedProduct(this.orderTimestamp, this.purchasedStatus, this.productId, this.quantity);

  factory PurchasedProduct.fromJson(Map<String, dynamic> data) {
    if(data==null){
      return null;
    }

    return PurchasedProduct(data["order_timestamp"],  data["purchase_status"], data["product_id"], data["quantity"]);


  }
}