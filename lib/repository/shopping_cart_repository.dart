import 'package:liv_farm/constant.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';

class ShoppingCartRepository {
  ServerService _cartsService =
      ServerService(api: API(endpoint: Endpoint.carts));
  ServerService _cartItemsService =
      ServerService(api: API(endpoint: Endpoint.cartItems));
  ServerService _recentCartService =
      ServerService(api: API(endpoint: Endpoint.recentCart));

  Future<List> fetchInitialCart(Map<String, dynamic> data) async {
    try {
      Map result = await _recentCartService.postData(data: data);
      if (result[MSG] == MSG_success) {
        return result[KEY_Result].cast() as List;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> postCartItems(Map data, int cartID) async {
    data[KEY_cartID] = cartID;
    await _cartItemsService.postData(data: data);
  }

  Future<int> postCartForInitAdd(Map data) async {
    try {
      Map result = await _cartsService.postData(data: data);
      if (result[MSG] == MSG_success) {
        print('dsdsd');
        return result[KEY_Result];
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<int> getCartItemsId(int cardId, int productId) async {
    Map result = await _cartItemsService.getData(
        params1: '/$cardId', params2: '/$productId');

    if (result[MSG] == MSG_success) {
      return result[KEY_Result];
    } else {
      return null;
    }
  }

  Future<Map> overrideCartItems(Map data, int cartId, int cartItemsId) async {
   Map result = await _cartItemsService.postData(
        data: data, params1: '/$cartItemsId');
   if (result[MSG] == MSG_success) {
     return result[KEY_Result];
   } else {
     return null;
   }
  }
}
