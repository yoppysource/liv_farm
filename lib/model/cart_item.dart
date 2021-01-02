import 'package:liv_farm/constant.dart';

class CartItem {
  int cartItemId;
  int productId;
  int quantity;
  int totalPrice;

  CartItem({
    this.cartItemId,
    this.productId,
    this.quantity,
    this.totalPrice,
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
      );
    }
  }

  Map<String, dynamic> toJson(CartItem cartItem){
    return {
      'cart_item_id' : cartItemId,
      'product_id' : productId,
      KEY_productQuantity : quantity,
      'total_price' : totalPrice,
    };
  }
}