import 'package:flutter/cupertino.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/repository/inventory_repository.dart';
import 'package:liv_farm/repository/review_repository.dart';
import 'package:liv_farm/service/analytic_service.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';
import 'package:liv_farm/utill/get_it.dart';

class ProductDescriptionViewmodel extends Formatter with ChangeNotifier {

  Product product;
  int inventory;
  bool isLazyLoaded = false;
  List<Review> reviewList;
  int bottomTabIndex = 0;

  InventoryRepository _repository = InventoryRepository();
  ReviewRepository _reviewRepository = ReviewRepository();

  get totalPrice =>
      getPriceFromInt(product.productPrice * product.productQuantity);

  ProductDescriptionViewmodel({@required Product product}) {
    this.product = Product.copy(product);
  }

  Future<void> lazyLoad() async {
    this.inventory = await _repository.getInventoryNum(this.product.id);
    this.reviewList = await _reviewRepository.getReviewData(this.product.id);
    await locator<AnalyticsService>().logViewItem(id: product.id, productName: product.productName, productCategory: Product.categoryMap[product.productCategory]);
    isLazyLoaded = true;
    notifyListeners();
  }


  void addQuantity() {
    if(product.productQuantity >= inventory){
      ToastMessage().showInventoryErrorToast();
      return;
    }

    product.productQuantity++;
    notifyListeners();
  }

  void subtractQuantity() {
    if (product.productQuantity >= 2) {
      product.productQuantity--;
      notifyListeners();
    }
  }
}
