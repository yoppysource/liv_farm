import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/product.dart';

class CartItem {
  int cartItemId;
  int productId;
  int quantity;
  int totalPrice;
  int cartId;
  int inventory;

  CartItem({
    this.cartItemId,
    this.productId,
    this.quantity,
    this.totalPrice,
    this.cartId,
    this.inventory,
});

  factory CartItem.fromJson(Map<String, dynamic> data) {
    if(data ==null){
      return null;
    }else{
      return CartItem(
        cartItemId: data['cart_item_id'],
        productId: data['product_id'],
        quantity: data[KEY_productQuantity],
        totalPrice: data['total_price'],
        cartId: data[KEY_cartID]
      );
    }
  }

  Map<String, dynamic> toJson(){
    return {
      'cart_item_id' : cartItemId,
      'product_id' : productId,
      KEY_productQuantity : quantity,
      'total_price' : totalPrice,
      KEY_cartID : cartId,
    };
  }
}