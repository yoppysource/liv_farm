import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:stacked/stacked.dart';

class AddToCartBottomSheetViewModel extends BaseViewModel {
  final Item item;

  AddToCartBottomSheetViewModel({required this.item});
  //   for (var inventory in inventoryList) {
  //     if (inventory.product.category == ProductCategory.dressing
  //         // ||
  //         //     inventory.product.category == ProductCategory.Protein
  //         ) {
  //       mapInventoryToQuantity[inventory] = 0;
  //     } else {
  //       mapInventoryToQuantity[inventory] = 1;
  //     }
  //   }
  // }
  int get price => item.options.isEmpty
      ? item.inventory.product.price
      : item.options.map((element) => element.price).fold(
          item.inventory.product.price,
          (previousValue, element) => previousValue + element);
  String get optionText => item.options.isEmpty
      ? ""
      : item.options
          .map((element) => element.name)
          .reduce((value, element) => value + ', ' + element);
  void addQuantity() {
    if (item.inventory.inventory > item.quantity) {
      item.quantity++;
      notifyListeners();
    } else {
      ToastMessageService.showToast(message: '재고가 부족합니다');
    }
  }

  void subtractQuantity() {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    } else {
      ToastMessageService.showToast(message: '1개 이상 선택 가능합니다');
    }
  }

  // void navigateToProductDetail(Inventory inventory) {
  //   _analyticsService.logViewItem(
  //     itemId: inventory.product.id,
  //     itemName: inventory.product.name,
  //     itemCategory: inventory.product.category.toString(),
  //   );

  //   _navigationService.navigateWithTransition(
  //       ProductDetailView(
  //         inventory: inventory,
  //       ),
  //       transition: 'fade');
  // }
}
