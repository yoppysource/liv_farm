import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/store_provider_service.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FarmViewModel extends FutureViewModel<void> {
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  ServerService _serverService = locator<ServerService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  StoreProviderService _storeProviderService = locator<StoreProviderService>();
  List eventsDataList;
  Map<ProductCategory, List<Inventory>> get inventoryMapByCategory =>
      _storeProviderService.inventoryMapByCategory;

  @override
  Future<void> futureToRun() async {
    this.eventsDataList =
        await _serverService.getData<List>(resource: Resource.events);

  }

  @override
  void onError(error) {
    if (error is APIException) {
      _dialogService.showDialog(title: "오류", description: error.message);
    } else {
      throw error;
    }
  }

  void navigateToProductDetailViewBySearchingProduct(Inventory inventory) {
    _analyticsService.logSearch(inventory.product.name);
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

  void onProductTap(Inventory inventory) {
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
