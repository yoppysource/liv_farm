import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/store_provider_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:liv_farm/util/category_enum.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OnlineFarmViewModel extends BaseViewModel {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final StoreProviderService _storeProviderService =
      locator<StoreProviderService>();
  final ClientService _clientService = locator<ClientService>();

  Map<ProductCategory, List<Inventory>> productCategoryToInventoryList = {};
  int get tabBarLength => productCategoryToInventoryList.length;

  List<Inventory> recommendedInventoryList = [];

  List<ProductCategory> get productCategoryList {
    List<ProductCategory> list = productCategoryToInventoryList.keys.toList();
    list.sort((a, b) => a.index.compareTo(b.index));
    return list;
  }

  void _setInventories(List<Inventory> inventoryList) {
    Map<ProductCategory, List<Inventory>> map = {};
    recommendedInventoryList = [];
    for (Inventory inventory in inventoryList) {
      if (inventory.recommended) recommendedInventoryList.add(inventory);
      if (map[inventory.product.productCategory] == null) {
        map[inventory.product.productCategory] = [inventory];
      } else {
        map[inventory.product.productCategory]!.add(inventory);
      }
    }
    productCategoryToInventoryList = map;
  }

  int get numOfTapbar => productCategoryToInventoryList.length;
  Future getInventories() async {
    try {
      List data = await _clientService.sendRequest<List>(
          method: HttpMethod.get,
          resource: Resource.inventories,
          endPath: "/store/${_storeProviderService.store!.id}");
      List<Inventory> inventoryList =
          data.map((e) => Inventory.fromJson(e)).toList();
      _setInventories(inventoryList);
    } catch (e) {
      ToastMessageService.showToast(message: "상품정보를 가져오는데 실패하였습니다.");
    }
  }

  void onProductTap(Inventory inventory) {
    _analyticsService.logViewItem(
      itemId: inventory.product.id,
      itemName: inventory.product.name,
      itemCategory: inventory.product.category.toString(),
    );
    _navigationService.navigateWithTransition(
        ProductDetailView(
          inventory: inventory,
        ),
        transition: 'fade');
  }

  void updateInventory(Inventory inventory) {
    int index =
        productCategoryToInventoryList[inventory.product.productCategory]!
            .indexWhere((element) => element.id == inventory.id);
    if (index != -1) {
      productCategoryToInventoryList[inventory.product.productCategory]![
          index] = inventory;
      notifyListeners();
    }
  }

  void navigateToProductDetailViewBySearchingProduct(Inventory inventory) {
    _analyticsService.logSearch(inventory.product.name);
    _analyticsService.logViewItem(
      itemId: inventory.product.id,
      itemName: inventory.product.name,
      itemCategory: inventory.product.category.toString(),
    );
    _navigationService.navigateWithTransition(
        ProductDetailView(
          inventory: inventory,
        ),
        transition: 'fade');
  }
}
