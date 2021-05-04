import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:stacked/stacked.dart';

class AddToCartBottomSheetViewModel extends BaseViewModel {
  Map<Product, int> mapProductToQuantity = Map();

  AddToCartBottomSheetViewModel(List<Product> productList) {
    productList.forEach((product) {
      if (product.category == ProductCategory.Dressing ||
          product.category == ProductCategory.Protein) {
        mapProductToQuantity[product] = 0;
      } else {
        mapProductToQuantity[product] = 1;
      }
    });
  }

  void addQuantity(Product product) {
    if (product.inventory > mapProductToQuantity[product]) {
      mapProductToQuantity[product]++;
      notifyListeners();
    } else {
      ToastMessageService.showToast(message: '재고가 부족합니다');
    }
  }

  void subtractQuantity(Product product) {
    if (product.inventory > mapProductToQuantity[product] ||
        mapProductToQuantity[product] > 0) {
      mapProductToQuantity[product]--;
      notifyListeners();
    }
  }
}
