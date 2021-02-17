import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';

class PaymentRepository {
  // ServerService _cartServerService =
  // ServerService(api: API(endpoint: Endpoint.carts));
  ServerService _purchaseServerService =
  ServerService(api: API(endpoint: Endpoint.purchases));

  // Future<void> updateCartsWhenPurchased({Map data, int cartId}) async {
  //   await _cartServerService.postData(data: data,params1: '/${cartId.toString()}');
  // }

  Future<Map> postPurchase(Purchase purchase) async {
    Map<String, dynamic> data = await _purchaseServerService.postData(data: purchase.toJson());
    return data;
  }
}