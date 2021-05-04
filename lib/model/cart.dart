import 'package:liv_farm/model/item.dart';

class Cart {
  List<Item> items;
  int totalPrice;
  int totalDiscountedPrice;
  String id;

  Cart({this.items, this.totalPrice, this.totalDiscountedPrice, this.id});

  Cart.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(new Item.fromJson(v));
      });
    }

    totalPrice = json['totalPrice'];
    totalDiscountedPrice = json['totalDiscountedPrice'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }

    data['totalPrice'] = this.totalPrice;
    data['totalDiscountedPrice'] = this.totalDiscountedPrice ?? 0;
    data['id'] = this.id;
    return data;
  }
}
