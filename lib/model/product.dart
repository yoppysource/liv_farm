import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/user_provider_service.dart';

enum ProductCategory {
  Vegetable,
  Salad,
  Grouped,
  Protein,
  Dressing,
}

class Product {
  UserProviderService _userProviderService = locator<UserProviderService>();
  bool get isPartner =>
      _userProviderService.user != null &&
      _userProviderService.user.role == 'partner';
  double ratingsAverage;
  int ratingsQuantity;
  String name;
  ProductCategory category;
  int price;
  String location;
  String nameInEng;
  String intro;
  List<Review> reviews;
  String id;
  String descriptionImgPath;
  String thumbnailPath;
  List detailImgPath;
  String weight;
  int discountedPrice;

  Product({
    this.ratingsAverage,
    this.ratingsQuantity,
    this.name,
    this.category,
    this.nameInEng,
    this.price,
    this.location,
    this.reviews,
    this.intro,
    this.id,
    this.descriptionImgPath,
    this.thumbnailPath,
    this.detailImgPath,
    this.weight,
    this.discountedPrice,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ratingsAverage = json['ratingsAverage']?.toDouble() ?? 4.5;
    ratingsQuantity = json['ratingsQuantity'] ?? 0;
   
    category =
        ProductCategory.values[json['category']] ?? ProductCategory.Vegetable;
    name = json['name'];
    nameInEng = json['nameInEng'];
    price =isPartner ?  json['partnerPrice']: json['price'];
 discountedPrice = isPartner ?json['partnerPrice'] : json['discountedPrice'] ?? json['price'];
    location = json['location'];
    intro = json['intro'];
    descriptionImgPath =
        Uri(scheme: scheme, port: hostPORT, host: hostIP).toString() +
            json['descriptionImgPath'];
    thumbnailPath =
        Uri(scheme: scheme, port: hostPORT, host: hostIP).toString() +
            json['thumbnailPath'];
    detailImgPath = json['detailImgPath']
            ?.map((e) =>
                Uri(
                  scheme: scheme,
                  port: hostPORT,
                  host: hostIP,
                ).toString() +
                e)
            ?.toList() ??
        <String>[];
    weight = json['weight'];
    if (json['reviews'] != null && json['reviews'].isNotEmpty) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews.add(new Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
