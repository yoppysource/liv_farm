import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddToCartBottomSheetViewModel extends BaseViewModel {
  Map<Inventory, int> mapInventoryToQuantity = Map();
  NavigationService _navigationService = locator<NavigationService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  AddToCartBottomSheetViewModel(List<Inventory> inventoryList) {
    inventoryList.forEach((Inventory inventory) {
      if (inventory.product.category == ProductCategory.Dressing ||
          inventory.product.category == ProductCategory.Protein) {
        mapInventoryToQuantity[inventory] = 0;
      } else {
        mapInventoryToQuantity[inventory] = 1;
      }
    });
  }

  void addQuantity(Inventory inventory) {
    if (inventory.inventory > mapInventoryToQuantity[inventory]) {
      mapInventoryToQuantity[inventory]++;
      notifyListeners();
    } else {
      ToastMessageService.showToast(message: '재고가 부족합니다');
    }
  }

  void subtractQuantity(Inventory inventory) {
    if (mapInventoryToQuantity[inventory] > 0) {
      mapInventoryToQuantity[inventory]--;
      notifyListeners();
    }
  }

  void navigateToProductDetail(Inventory inventory) {
    _analyticsService.logViewItem(
        itemId: inventory.product.id,
        itemName: inventory.product.name,
        itemCategory: inventory.product.category.toString(),
        price: inventory.product.price.toDouble(),
        currency: 'won');

    _navigationService.navigateWithTransition(
        ProductDetailView(
          inventory: inventory,
        ),
        transition: 'fade');
  }
}
