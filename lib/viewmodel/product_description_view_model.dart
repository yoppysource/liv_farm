import 'package:flutter/cupertino.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';

class ProductDescriptionViewmodel extends Formatter with ChangeNotifier {
  Product product;

  get totalPrice =>
      getPriceFromInt(product.productPrice * product.productQuantity);

  ProductDescriptionViewmodel({@required Product product}) {
    this.product = Product.copy(product);
  }

  void addQuantity() {
    product.productQuantity++;
    notifyListeners();
  }

  void subtractQuantity() {
    if (product.productQuantity >= 2) {
      product.productQuantity--;
      notifyListeners();
    }
  }
}
