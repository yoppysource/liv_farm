// import 'package:liv_farm/app/app.locator.dart';
// import 'package:liv_farm/model/inventory.dart';
// import 'package:liv_farm/model/product.dart';
// import 'package:liv_farm/services/analytics_service.dart';
// import 'package:liv_farm/services/store_provider_service.dart';
// import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
// import 'package:stacked/stacked.dart';
// import 'package:stacked_services/stacked_services.dart';

// class BaseFarmViewModel extends BaseViewModel {
//   final AnalyticsService _analyticsService = locator<AnalyticsService>();
//   final NavigationService _navigationService = locator<NavigationService>();
//   final StoreProviderService _storeProviderService =
//       locator<StoreProviderService>();
//   Map<ProductCategory, List<Inventory>> get inventoryMapByCategory =>
//       _storeProviderService.inventoryMapByCategory;

//   void onProductTap(Inventory inventory) {
//     _analyticsService.logViewItem(
//       itemId: inventory.product.id,
//       itemName: inventory.product.name,
//       itemCategory: inventory.product.category.toString(),
//     );
//     _navigationService.navigateWithTransition(
//         ProductDetailView(
//           inventory: inventory,
//         ),
//         transition: 'fade');
//   }
// }
