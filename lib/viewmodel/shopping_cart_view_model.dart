import 'package:flutter/foundation.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';

class ShoppingCartViewmodel with ChangeNotifier {
  List<Product> shoppingCart = [];

  ShoppingCartViewmodel() {
    //TODO: 서버에서 가져오깅
  }

  int shoppingCartID;
  ServerService _cartsServerService =
      ServerService(api: API(endpoint: Endpoint.carts));
  ServerService _itemsServerService =
      ServerService(api: API(endpoint: Endpoint.cartItems));

  Future<void> _sendCartItemDataToSever(Product product) async {
    await _itemsServerService.postData(
        data: product.toJson(), params1: '/${this.shoppingCartID.toString()}');
  }

  Future<void> addProduct(Product product, int customerId) async {
    print('addProduct');
    print('shopping_list_length : ${shoppingCart.length}');

    if (shoppingCart.isEmpty) {
      shoppingCartID = await _cartsServerService.postData(data: {
        KEY_customer_uid: customerId,
        KEY_cartStatus: 0,
      });
      print(shoppingCartID);
      await _sendCartItemDataToSever(product);
      shoppingCart.add(product);
      notifyListeners();
      return;
    } else {
      for (Product existedProduct in shoppingCart) {
        if (existedProduct.id == product.id) {
          print('중복되는 상품 : ' + existedProduct.id.toString());
          existedProduct.quantity += product.quantity;
          int cartItemsId = await _cartsServerService.getData();
          await _itemsServerService.postData(
              data: product.toJson(),
              params1: '/{${this.shoppingCartID}',
              params2: '/$cartItemsId');
          return;
        }
      }
      await _sendCartItemDataToSever(product);
      shoppingCart.add(product);
      notifyListeners();
    }
  }

  Future<void> deleteProduct(Product product) async {
    product.quantity = 0;
    int cartItemsId = await _itemsServerService.getData(params1: '/${this.shoppingCartID}', params2: '${product.id}');
    await _itemsServerService.postData(data: product.toJson(), params1: '/$cartItemsId');
    shoppingCart.remove(product);
    notifyListeners();
  }

  Future<void> addQuantityOfProduct(Product product) async {
    product.quantity += 1;
    int cartItemsId = await _itemsServerService.getData(params1: '/${this.shoppingCartID}', params2: '${product.id}');
    await _itemsServerService.postData(data: product.toJson(), params1: '/$cartItemsId');
    notifyListeners();
  }

  Future<void> removeQuantityOfProduct(Product product) async {
    if(product.quantity == 1){
      await deleteProduct(product);
      notifyListeners();
    }
    product.quantity -= 1;
    int cartItemsId = await _itemsServerService.getData(params1: '/${this.shoppingCartID}', params2: '${product.id}');
    await _itemsServerService.postData(data: product.toJson(), params1: '/$cartItemsId');
    notifyListeners();
  }

  void clearCart() {
    shoppingCart = [];
    notifyListeners();
  }

  int get totalPrice {
    if (shoppingCart.length == 0) {
      return 0;
    }
    int sumOfPrice = 0;
    for (int i = 0; i < shoppingCart.length; i++) {
      sumOfPrice += (shoppingCart[i].quantity * shoppingCart[i].price);
    }
    return sumOfPrice;
  }
}
