import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/product.dart';

class Item {
  int quantity;
  String id;
  Product product;

  Item({this.quantity, this.id, this.product});

  Item.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    id = json['_id'];
    product = new Product.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['_id'] = this.id;
    data['product'] = this.product.toJson();

    return data;
  }
}
