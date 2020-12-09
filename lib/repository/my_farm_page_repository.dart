import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';

class MyFarmPageRepository {
  ServerService _purchaseServerService = ServerService(
    api: API(endpoint: Endpoint.purchases),
  );

  ServerService _historyServerService = ServerService(
    api: API(
      endpoint: Endpoint.purchaseHistory,
    ),
  );

  Future<List<Purchase>> fetchPurchaseData(int customerId) async {
    Map<String, dynamic> result = await _purchaseServerService.getData(
      params1: '/customer',
      //TODO: For testing
      params2: '/32',
    );
    if (result[MSG] == MSG_success) {
      List<dynamic> purchasesDataList = result[KEY_Result].cast() as List;
      if (purchasesDataList.isEmpty) {
        print('isempty!');
        return [];
      }
      List<Purchase> purchasesList = purchasesDataList
          .map((i) => Purchase.fromJson(i))
          .toList()
          .reversed
          .toList();
      return purchasesList;
    } else {
      return null;
    }
  }

  Future<Map> fetchProductIdPairedWithQuantity(Purchase purchase) async {
    try {
      Map<int, int> productIdPairedWithQuantity = Map();
      dynamic data = await _historyServerService.getData(
          params1: '/${purchase.cartId}');
      if(data[MSG] == MSG_fail){
        return null;
      }
      List dataList = data['result'] as List;
      print('fetch');

      for (Map data in dataList) {
        if (data[KEY_productQuantity] == 0) {
          continue;
        } else if (productIdPairedWithQuantity.keys.
            contains(data[KEY_productID])) {
          productIdPairedWithQuantity[data[KEY_productID]] +=
              data[KEY_productQuantity];
          continue;
        } else {
          productIdPairedWithQuantity[data[KEY_productID]] =
              data[KEY_productQuantity];
        }
        print('done');
      }
      return productIdPairedWithQuantity;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
