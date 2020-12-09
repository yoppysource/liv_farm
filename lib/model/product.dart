import 'package:flutter/cupertino.dart';

import '../constant.dart';

class Product {
  final int id;
  final String category;
  final String name;
  final int price;
  final String location;
  final String description;
  final String imagePath;
  int quantity;

  static const Map<int,String> categoryToString = {
    1: '1의 카테고리명',
    2: '2의 카테고리명',
    3: '3의 카테고리명',
  };

  Product(
      {@required this.id,
        @required this.category,
        @required this.name,
        @required this.price,
        this.location,
        this.description,
        this.imagePath,
        this.quantity});

  //json -> object
  factory Product.fromJson({Map<String, dynamic> data}) {
    if (data == null) {
      return null;
    }
    return Product(
      id: data[KEY_productID],
      category: categoryToString[data[KEY_category]],
      name: data[KEY_productName],
      price: data[KEY_productPrice],
      location: data[KEY_location],
      description: data[KEY_description],
      imagePath: data[KEY_imagePath],
      // if quantity is null(when user scan the product initially), should be 1.
      quantity: data[KEY_productQuantity] ?? 1,
    );
  }

  // Send to server
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      KEY_productID: id,
      KEY_productQuantity: quantity,
      KEY_totalPrice: price * quantity,
    };
  }
}
