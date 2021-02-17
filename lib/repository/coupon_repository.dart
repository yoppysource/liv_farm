import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';
import '../constant.dart';

class CouponRepository {
  ServerService _promotionCouponService = ServerService(
      api: API(endpoint: Endpoint.promotionCoupon));
  ServerService _couponService = ServerService(
      api: API(endpoint: Endpoint.coupon));
  ServerService _couponFromCustomerService = ServerService(
      api: API(endpoint: Endpoint.couponCustomer));

  Future<List<Coupon>> getCustomerCoupon(int customerID) async {
    Map<String, dynamic>data = await _couponFromCustomerService.getData(
        params1: '/$customerID');
    if (data[MSG] == MSG_fail) {
      return List();
    } else {
      print('${data[KEY_Result]}');
      try{
        List jsonList = data[KEY_Result] as List;
        print(jsonList);
        List<Coupon> couponList =jsonList.map((e) => Coupon.fromJson(data: e)).toList();
        return couponList;
      } catch(e){
        return List();
      }

    }
  }
  Future<bool> registerCoupon(int customerID, String input)async{
   Map<String, dynamic> data = await _promotionCouponService.postData(data: {
      "customer_id": customerID,
      "promo_num":input
    });
   if (data[MSG] == MSG_success) {
     return true;
   } else {
     return false;
   }
  }
  Future<void> usedCoupon(int couponID) async {
    await _couponService.postData(data: {
      "used":1
    }, params1: '/$couponID');
  }
}