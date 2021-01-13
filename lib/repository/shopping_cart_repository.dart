import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/cart_item.dart';
import 'package:liv_farm/repository/inventory_repository.dart';
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
        List dataList = result[KEY_Result].cast() as List;
        List<CartItem> initialCart = dataList.map((e) => CartItem.fromJson(e)).toList();
        if(initialCart.isNotEmpty){
          for (CartItem item in initialCart) {
           int inventory = await InventoryRepository().getInventoryNum(item.productId);
           item.inventory = inventory;
          }
        }
        return initialCart;
      } else {
        return List<CartItem>();
      }
    } catch (e) {
      print(e.toString());
      return List<CartItem>();
    }
  }

  Future<int> postCartItems(Map data) async {
   Map result =  await _cartItemsService.postData(data: data);
    if (result[MSG] == MSG_success) {
      return result[KEY_Result]['cart_item_id'];
    } else {
      return null;
    }
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
