import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../constant.dart';

// Nutrition	영양정보	VARCHAR(45)	N/A	문장	X
class Product {
  final int id;
  final String productName;
  final String productNameInEng;
  final int productPrice;
  final String productLocation;
  final String productDescription;
  final String imagePath;
  int productQuantity;
  final int productCategory;
  final String productIntro;

  Product(
      {@required this.id,
      @required this.productName,
      @required this.productNameInEng,
      @required this.productPrice,
      @required this.productLocation,
      @required this.productDescription,
      @required this.imagePath,
      @required this.productCategory,
      @required this.productIntro,
      this.productQuantity});

  //json -> object
  static Map<int, String> categoryMap= {
  1: '샐러드',
  2: '샘플러',
  4:  '상추',
  5: '치커리',
  6: '케일',
  7: '청경채',
  8: '허브',
  9: '프로틴',
  10: '드레싱',
  };


  factory Product.fromJson({Map<String, dynamic> data}) {
    if (data == null) {
      return null;
    }
    return Product(
      id: data[KEY_productID],
      productName: data[KEY_productName],
      productNameInEng: data[KEY_productNameInEng],
      productPrice: data[KEY_productPrice],
      productLocation: data[KEY_productLocation],
      productDescription: data[KEY_productDescription],
      imagePath: data[KEY_imagePath],
      productCategory: int.tryParse(data[KEY_productCategory]),
      productIntro: data[KEY_productIntro],
      // if quantity is null(when user scan the product initially), should be 1.
      productQuantity: data[KEY_productQuantity] ?? 1,
    );
  }

  factory Product.copy(Product product){
    return Product(
      id: product.id,
      productName: product.productName,
      productNameInEng: product.productNameInEng,
      productPrice: product.productPrice,
      productLocation: product.productLocation,
      productDescription: product.productDescription,
      imagePath: product.imagePath,
      productCategory: product.productCategory,
      productIntro: product.productIntro,
      // if quantity is null(when user scan the product initially), should be 1.
      productQuantity: 1,
    );
  }
}
