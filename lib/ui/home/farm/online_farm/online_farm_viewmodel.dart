import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/ui/home/farm/base_farm_viewmodel.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:stacked_services/stacked_services.dart';

class OnlineFarmViewModel extends BaseFarmViewModel {
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  NavigationService _navigationService = locator<NavigationService>();

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
}
