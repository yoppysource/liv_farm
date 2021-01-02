import 'package:flutter/cupertino.dart';
import 'package:liv_farm/constant.dart';

class Review {
  final int id;
  final int customerId;
  final int productId;
  final double rating;
  final String comment;
  final DateTime createAt;

  Review(
      {this.id,
      this.customerId,
      @required this.productId,
      @required this.rating,
      @required this.comment,
      this.createAt});

  factory Review.fromJson(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      return Review(
          id: data[Review_id],
          rating: data[Review_rating].toDouble(),
          customerId: data[Review_customer_id],
          productId: data[Review_product_id],
          comment: data[Review_comment],
          createAt: DateTime.tryParse(data[Review_createdAt]));
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      Review_rating: rating,
      Review_customer_id: customerId,
      Review_product_id: productId,
      Review_comment: comment,
      Review_createdAt: createAt,
    };
  }
}
