import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/util/category_enum.dart';

class Product {
  late final double ratingsAverage;
  late final int ratingsQuantity;
  late final String name;
  late final int category;
  late final int price;
  late final String nameInEng;
  late final String intro;
  List<Review>? reviews;
  late final String id;
  late final String descriptionImgPath;
  late final String thumbnailPath;
  late final String weight;

  Product({
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.name,
    required this.category,
    required this.nameInEng,
    required this.price,
    this.reviews,
    required this.intro,
    required this.id,
    required this.descriptionImgPath,
    required this.thumbnailPath,
    required this.weight,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ratingsAverage = json['ratingsAverage']?.toDouble() ?? 4.5;
    ratingsQuantity = json['ratingsQuantity'] ?? 0;
    category = json['category'];
    name = json['name'];
    nameInEng = json['nameInEng'];
    price = json['price'];
    intro = json['intro'];
    descriptionImgPath =
        Uri(scheme: scheme, port: hostPORT, host: hostIP).toString() +
            json['descriptionImgPath'];
    thumbnailPath =
        Uri(scheme: scheme, port: hostPORT, host: hostIP).toString() +
            json['thumbnailPath'];

    weight = json['weight'];
    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews!.add(Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

extension ProductExtension on Product {
  ProductCategory get productCategory => ProductCategory.values[category];
}
