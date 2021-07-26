import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/item.dart';

class Cart {
  List<Item> items;
  int totalPrice;
  int totalDiscountedPrice;
  String id;
  String storeId;

  Cart(
      {this.items,
      this.totalPrice,
      this.totalDiscountedPrice,
      this.id,
      this.storeId});

  Cart.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(new Item.fromJson(v));
      });
    }
    storeId = json['storeId'];
    totalPrice = json['totalPrice'];
    totalDiscountedPrice = json['totalDiscountedPrice'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['storeId'] = this.storeId;

    data['totalPrice'] = this.totalPrice;
    data['totalDiscountedPrice'] = this.totalDiscountedPrice ?? 0;
    data['id'] = this.id;
    return data;
  }
}

class Item {
  int quantity;
  String id;
  Inventory inventory;

  Item({this.quantity, this.id, this.inventory});

  Item.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    id = json['id'];
    inventory = new Inventory.fromJson(json['inventory']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['id'] = this.id;
    return data;
  }
}
