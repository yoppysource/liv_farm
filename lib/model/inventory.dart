import 'package:liv_farm/model/product.dart';

class Inventory {
  int inventory;
  int rank;
  bool isOnShelf;
  bool hidden;
  String store;
  Product product;
  String id;

  Inventory(
      {this.inventory,
      this.rank,
      this.isOnShelf,
      this.hidden,
      this.store,
      this.product,
      this.id});

  Inventory.fromJson(Map<String, dynamic> json) {
    inventory = json['inventory'];
    rank = json['rank'];
    isOnShelf = json['isOnShelf'];
    hidden = json['hidden'];
    store = json['store'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inventory'] = this.inventory;
    data['rank'] = this.rank;
    data['isOnShelf'] = this.isOnShelf;
    data['hidden'] = this.hidden;
    data['store'] = this.store;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}