import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/option_group.dart';

class Cart {
  late final List<Item> items;
  late final int totalPrice;
  late final int? totalDiscountedPrice;
  late final String id;
  String? storeId;

  Cart(
      {required this.items,
      required this.totalPrice,
      required this.totalDiscountedPrice,
      required this.id,
      required this.storeId});

  Cart.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(Item.fromJson(v));
      });
    }
    if (json['storeId'] != null) storeId = json['storeId'];
    totalPrice = json['totalPrice'];
    totalDiscountedPrice = json['totalDiscountedPrice'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items.isNotEmpty) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    data['storeId'] = storeId;
    data['totalPrice'] = totalPrice;
    data['totalDiscountedPrice'] = totalDiscountedPrice ?? 0;
    data['id'] = id;
    return data;
  }
}

class Item {
  late int quantity;
  String? id;
  late final Inventory inventory;
  late final List<Option> options;

  Item(
      {required this.quantity,
      this.id,
      required this.inventory,
      required this.options});

  Item.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    id = json['_id'];
    inventory = Inventory.fromJson(json['inventory']);
    options =
        List.from(json['options']).map((e) => Option.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inventory'] = inventory.id;
    data['quantity'] = quantity;
    data['id'] = id;
    data['options'] = options.map((e) => e.toJson()).toList();
    return data;
  }
}
