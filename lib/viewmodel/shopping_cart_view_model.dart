import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/cart_item.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/repository/inventory_repository.dart';
import 'package:liv_farm/repository/shopping_cart_repository.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';

class ShoppingCartViewmodel with ChangeNotifier {
  MyUser myUser;
  List<CartItem> shoppingCart = [];
  Coupon coupon;

  void applyCoupon(Coupon coupon) {
    this.coupon = coupon;
    notifyListeners();
  }

  get deliveryFee {
    if (shoppingCart.isNotEmpty) {
      if(totalPrice< 20000){
        return 3000;
      } else{
        return 1000;
      }
    } else {
      return 0;
    }
  }

  get totalAmount {
    return deliveryFee + totalPrice - discountAmount;
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
      sumOfPrice += shoppingCart[i].totalPrice;
    }
    return sumOfPrice;
  }

  int get discountAmount{
    if(this.coupon!=null && totalPrice != 0) {
      if(this.coupon.type == 1) {
        if(this.coupon.value > totalPrice){
          return 0;
        } else {
          return this.coupon.value.toInt();
        }
      } else {
        return (totalPrice * (coupon.value)).toInt();
      }
    } else {
      return 0;
    }
  }

  int shoppingCartID;

  ShoppingCartViewmodel(MyUser user) {
    myUser = user;
    init();
  }

  ShoppingCartRepository _shoppingCartRepository = ShoppingCartRepository();

  Future<void> init() async {
    Map<String, dynamic> data = Map();
    data[KEY_customer_uid] = myUser.id;
    data[KEY_cartStatus] = 0;
    print(data.toString());
    List<CartItem> initShoppingCart = await _shoppingCartRepository.fetchInitialCart(data);
    if (initShoppingCart.isNotEmpty) {
      this.shoppingCartID = initShoppingCart[0].cartId;
      this.shoppingCart = initShoppingCart;
      notifyListeners();
    }else{
      shoppingCart = List<CartItem>();
    }
  }

  Future<Purchase> createPurchaseData() async {
    for (CartItem item in this.shoppingCart) {
      int inventory = await InventoryRepository().getInventoryNum(item.productId);
      if(item.quantity > inventory){
        return null;
      }
    }


    return Purchase(
      customerId: myUser.id,
      cartId: shoppingCartID,
      purchaseStatus: 0,
      deliveryAddress: "${myUser.address} ${myUser.addressDetail}",
      deliveryOption: 0,
      orderTimestamp: DateTime.now().toIso8601String(),
    );
  }

  Future<void> addProduct(Product product, int customerId, int inventory) async {
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
      for (CartItem item in shoppingCart) {
        if (item.productId == product.id) {
          await changeQuantityOfProduct(item, product.productQuantity);
          ToastMessage().showCartAddQuantityToast();
          return;
        }
      }
    }
    CartItem cartItem = CartItem(
      cartId: this.shoppingCartID,
      productId: product.id,
      quantity: product.productQuantity,
      totalPrice: product.productPrice*product.productQuantity,
      inventory: inventory,
    );
    int cartItemId = await _shoppingCartRepository.postCartItems(
       cartItem.toJson());
    if(cartItemId == null){
      ToastMessage().showErrorToast();
      return;
    }
    cartItem.cartItemId = cartItemId;
    shoppingCart.add(cartItem);
    notifyListeners();
    ToastMessage().showCartSuccessToast();
  }

  void rebuildWidget() {
    notifyListeners();
  }

  Future<void> deleteProduct(CartItem cartItem) async {
    cartItem.quantity = 0;
    await _shoppingCartRepository.overrideCartItems(
        {KEY_productQuantity: 0},
        this.shoppingCartID,
        cartItem.cartItemId);

    shoppingCart.remove(cartItem);
    notifyListeners();
  }

  Future<void> changeQuantityOfProduct(CartItem cartItem ,int num) async {
    if((cartItem.inventory <= cartItem.quantity) && (num>0)){
      ToastMessage().showInventoryErrorToast();
      return;
    }
    int price = cartItem.totalPrice~/cartItem.quantity;
    cartItem.totalPrice += price*num;
    cartItem.quantity += num;
    notifyListeners();
    Map result = await _shoppingCartRepository.overrideCartItems(
        {KEY_productQuantity: cartItem.quantity,
          KEY_totalPrice: cartItem.totalPrice,
        },
        this.shoppingCartID,
        cartItem.cartItemId);
    print(result.toString());
    notifyListeners();
  }
  getCoupon(Coupon coupon) {
    this.coupon =coupon;
  }

  void clearCart() {
    this.shoppingCartID = null;
    shoppingCart = [];
    notifyListeners();
  }
}
