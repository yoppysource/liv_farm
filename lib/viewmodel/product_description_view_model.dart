import 'package:flutter/cupertino.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';

class ProductDescriptionViewmodel extends Formatter with ChangeNotifier {

  final Product product;

  get totalPrice => getPriceFromInt(product.quantity * product.price);

  ProductDescriptionViewmodel({@required this.product});

  void addQuantity() {
    product.quantity++;
    notifyListeners();
  }

  void subtractQuantity() {
    if (product.quantity >= 2) {
      product.quantity--;
      notifyListeners();
    }
  }
}
