import 'package:flutter/cupertino.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/repository/review_repository.dart';

class ReviewPageViewModel with ChangeNotifier {
  ReviewRepository _repository = ReviewRepository();
  final int productId;
  List<Review> reviewList;
  bool isBusy = false;

  ReviewPageViewModel(this.productId) {
    Future.microtask(() async => await init());
  }

  Future<void> init() async {
    isBusy = true;
    notifyListeners();
    reviewList = await _repository.getReviewData(productId);
    isBusy = false;
    notifyListeners();
  }
}
