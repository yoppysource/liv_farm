import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/repository/online_shopping_repository.dart';
import 'package:liv_farm/repository/shopping_cart_repository.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';

class ShoppingCartViewmodel with ChangeNotifier {
  MyUser myUser;
  List<Product> shoppingCart = [];

  get deliveryFee {
    if (shoppingCart.isNotEmpty) {
      return 3000;
    } else {
      return 0;
    }
  }

  get totalAmount {
    return deliveryFee + totalPrice;
  }

  get isInformationAvailable {
    if (myUser.name == '' ||
        myUser.postCode == '' ||
        myUser.address == '' ||
        myUser.addressDetail == '' ||
        myUser.phoneNumber == '') {
      return false;
    } else {
      return true;
    }
  }

  int get totalPrice {
    if (shoppingCart.length == 0) {
      return 0;
    }
    int sumOfPrice = 0;
    for (int i = 0; i < shoppingCart.length; i++) {
      sumOfPrice +=
          (shoppingCart[i].productQuantity * shoppingCart[i].productPrice);
    }
    return sumOfPrice;
  }

  int shoppingCartID;

  ShoppingCartViewmodel(MyUser user) {
    myUser = user;
    Future.microtask(() async => await init());
  }

  OnlineShoppingRepository _onlineShoppingRepository =
      OnlineShoppingRepository();
  ShoppingCartRepository _shoppingCartRepository = ShoppingCartRepository();

  Future<void> init() async {
    Map<String, dynamic> data = Map();
    data[KEY_customer_uid] = myUser.id;
    data[KEY_cartStatus] = 0;
    print(data.toString());
    List cartRawList = await _shoppingCartRepository.fetchInitialCart(data);
    if (cartRawList != null && cartRawList.isNotEmpty) {
      List<Product> productList =
          await _onlineShoppingRepository.fetchProductListFromServer();
      this.shoppingCartID = cartRawList[0][KEY_cartID];
      List<Product> initProductList = cartRawList
          .map((i) {
            Product product = productList
                .firstWhere((product) => product.id == i[KEY_productID]);
            print('${i[KEY_productQuantity]}');
            product.productQuantity = i[KEY_productQuantity];
            return product;
          })
          .toList()
          .reversed
          .toList();
      print('${initProductList[0].productQuantity.toString()} g한');
      shoppingCart = initProductList;
      notifyListeners();
    }
  }

  Purchase createPurchaseData() {
    return Purchase(
      customerId: myUser.id,
      cartId: shoppingCartID,
      deliveryAddress: "${myUser.address} ${myUser.addressDetail}",
      deliveryOption: 0,
      orderTimestamp: DateTime.now().toIso8601String(),
    );
  }

  Future<void> addProduct(Product product, int customerId) async {
    print('addProduct');
    print('shopping_list_length : ${shoppingCart.length}');

    if (shoppingCart.isEmpty) {
      int result = await _shoppingCartRepository.postCartForInitAdd({
        KEY_customer_uid: customerId,
        KEY_cartStatus: 0,
      });
      print(result);
      if (result == null) {
        ToastMessage().showErrorToast();
        return;
      }
      this.shoppingCartID = result;
      print(shoppingCartID);
    } else {
      for (Product existedProduct in shoppingCart) {
        if (existedProduct.id == product.id) {
          print('중복되는 상품 : ' + existedProduct.id.toString());
          existedProduct.productQuantity += product.productQuantity;
        int cartItemsId = await _shoppingCartRepository.getCartItemsId(this.shoppingCartID, product.id);
        if(cartItemsId == null){
          ToastMessage().showErrorToast();
          return;
        }
        await _shoppingCartRepository.overrideCartItems(
            {KEY_productQuantity: product.productQuantity},
              this.shoppingCartID,
             cartItemsId);
          return;
        }
      }
    }
    await _shoppingCartRepository.postCartItems(
        product.toJson(), this.shoppingCartID);
    shoppingCart.add(product);
    notifyListeners();
    ToastMessage().showCartSuccessToast();
  }

  void rebuildWidget() {
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    product.productQuantity = 0;
    int cartItemsId = await _shoppingCartRepository.getCartItemsId(this.shoppingCartID, product.id);
    if(cartItemsId == null){
      ToastMessage().showErrorToast();
      return;
    }
    await _shoppingCartRepository.overrideCartItems(
        {KEY_productQuantity: product.productQuantity},
        this.shoppingCartID,
        cartItemsId);
    shoppingCart.remove(product);
    notifyListeners();
  }

  Future<void> addQuantityOfProduct(Product product) async {
    product.productQuantity += 1;
    int cartItemsId = await _shoppingCartRepository.getCartItemsId(this.shoppingCartID, product.id);
    if(cartItemsId == null){
      ToastMessage().showErrorToast();
      return;
    }
    Map result = await _shoppingCartRepository.overrideCartItems(
        {KEY_productQuantity: product.productQuantity},
        this.shoppingCartID,
        cartItemsId);
    print(result.toString());
    notifyListeners();
  }

  Future<void> removeQuantityOfProduct(Product product) async {
    if (product.productQuantity == 1) {
      await deleteProduct(product);
      notifyListeners();
    }
    product.productQuantity -= 1;
    notifyListeners();
    int cartItemsId = await _shoppingCartRepository.getCartItemsId(this.shoppingCartID, product.id);
    if(cartItemsId == null){
      ToastMessage().showErrorToast();
      return;
    }
    await _shoppingCartRepository.overrideCartItems(
        {KEY_productQuantity: product.productQuantity},
        this.shoppingCartID,
        cartItemsId);
    notifyListeners();
  }

  void clearCart() {
    shoppingCart = [];
    notifyListeners();
  }
}
