import 'package:liv_farm/model/product.dart';

class PurchaseWithProducts {
  final String orderTimestamp;
  final int purchasedStatus;
  final List<dynamic> productDataList;

  static Map<int, String> purchasedStatusMap = {
    0: '결제완료',
    1: '포장 중',
    2: '배송 중',
    3: '전달 완료',
    4: '환불 처리',
  };

  PurchaseWithProducts(this.orderTimestamp, this.purchasedStatus, this.productDataList);

  factory PurchaseWithProducts.fromJson(Map<String, dynamic> data) {
    if(data==null){
      return null;
    }

    return PurchaseWithProducts(data["order_timestamp"],  data["purchase_status"], data["product_list"]);


  }
}