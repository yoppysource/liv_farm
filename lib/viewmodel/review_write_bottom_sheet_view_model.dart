import 'package:flutter/cupertino.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/repository/review_repository.dart';

class ReviewWriteBottomSheetViewModel{

  ReviewRepository _repository = ReviewRepository();

  Future<Map> submit(Review review) async {
    return await _repository.postReviewData(review);
  }
}