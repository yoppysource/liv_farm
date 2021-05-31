import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FarmViewModel
    extends FutureViewModel<Map<ProductCategory, List<Product>>> {
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  ServerService _serverService =
      ServerService(apiPath: APIPath(resource: Resource.products));
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  ServerService _eventServerService =
      ServerService(apiPath: APIPath(resource: Resource.events));

  @override
  Future<Map<ProductCategory, List<Product>>> futureToRun() async {
    try {
      Map<String, dynamic> data = await _serverService.getData();
      Map<String, dynamic> eventData = await _eventServerService.getData();
      this.eventsList = eventData['data'] as List;
      List productData = data['data'] as List;
      List productList = productData.map((e) => Product.fromJson(e)).toList();
      return createMapByCategory(productList);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void onError(error) {
    if (error is APIException) {
      _dialogService.showDialog(title: "오류", description: error.message);
    } else {
      throw error;
      // _dialogService.showDialog(title: "??", description: error.toString());
    }
  }

  List eventsList = [];

  Map<ProductCategory, List<Product>> createMapByCategory(
      List<Product> productList) {
    Map<ProductCategory, List<Product>> productMapByCategory = {
      ProductCategory.Vegetable: <Product>[],
      ProductCategory.Salad: <Product>[],
      ProductCategory.Grouped: <Product>[],
      ProductCategory.Protein: <Product>[],
      ProductCategory.Dressing: <Product>[],
    };
    productList.forEach((element) {
      switch (element.category) {
        case ProductCategory.Vegetable:
          return productMapByCategory[ProductCategory.Vegetable].add(element);
        case ProductCategory.Salad:
          return productMapByCategory[ProductCategory.Salad].add(element);
        case ProductCategory.Grouped:
          return productMapByCategory[ProductCategory.Grouped].add(element);
        case ProductCategory.Protein:
          return productMapByCategory[ProductCategory.Protein].add(element);
        case ProductCategory.Dressing:
          return productMapByCategory[ProductCategory.Dressing].add(element);
        default:
          return productMapByCategory[ProductCategory.Vegetable].add(element);
      }
    });

    return productMapByCategory;
  }

  void rebuildFarmView() {
    notifyListeners();
  }

  void navigateToProductDetailViewBySearchingProduct(Product product) {
    _analyticsService.logSearch(product.name);
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

  void onProductTap(Product product) {
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
