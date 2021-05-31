import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddToCartBottomSheetViewModel extends BaseViewModel {
  Map<Product, int> mapProductToQuantity = Map();
  NavigationService _navigationService = locator<NavigationService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

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
    if (mapProductToQuantity[product] > 0) {
      mapProductToQuantity[product]--;
      notifyListeners();
    }
  }

  void navigateToProductDetail(Product product) {
    _analyticsService.logViewItem(
        itemId: product.id,
        itemName: product.name,
        itemCategory: product.category.toString(),
        price: product.price.toDouble(),
        currency: 'won');

    _navigationService.navigateWithTransition(
        ProductDetailView(
          product: product,
        ),
        transition: 'fade');
  }
}
