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
  final int productHardness;
  final int productTaste;
  final String productStorageDes;
  final String productRecipe;

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
      @required this.productHardness,
      @required this.productTaste,
      @required this.productStorageDes,
      @required this.productRecipe,
      this.productQuantity});

  //json -> object


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
      productCategory: data[KEY_productCategory],
      productIntro: data[KEY_productIntro],
      productHardness: data[KEY_productHardness],
      productTaste: data[KEY_productTaste],
      productStorageDes: data[KEY_productStorageDes],
      productRecipe: data[KEY_productRecipe],
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
      productHardness:product.productHardness,
      productTaste: product.productTaste,
      productStorageDes: product.productStorageDes,
      productRecipe: product.productRecipe,
      // if quantity is null(when user scan the product initially), should be 1.
      productQuantity: 1,
    );
  }
  // Send to server
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      KEY_productID: id,
      KEY_productQuantity: productQuantity,
      KEY_totalPrice: productPrice * productQuantity,
    };
  }

}
