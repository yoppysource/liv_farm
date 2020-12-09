import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';

class OnlineShoppingRepository {
  ServerService _serverService =
  ServerService(api: API(endpoint: Endpoint.products));



  Future<List> fetchProductListFromServer() async {
    print('function call');
    Map<String, dynamic> data = await _serverService.getData();
    if (data[MSG] == MSG_fail) {
      return [];
    } else {
      print('${data[KEY_Result]}');
      List jsonList = data[KEY_Result] as List;
      List<Product> productList = jsonList.map((e) {
        if (e[KEY_productName] != null) {
          return Product.fromJson(data: e);
        }
      }).toList();
      return productList;
    }
  }
}