import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FarmViewModel
    extends FutureViewModel<Map<ProductCategory, List<Product>>> {
  ServerService _serverService =
      ServerService(apiPath: APIPath(resource: Resource.products));
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  @override
  Future<Map<ProductCategory, List<Product>>> futureToRun() async {
    Map<String, dynamic> data = await _serverService.getData();
    List productData = data['data'] as List;
    List productList = productData.map((e) => Product.fromJson(e)).toList();
    return createMapByCategory(productList);
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

  void onProductTap(Product product) {
    _navigationService.navigateWithTransition(
        ProductDetailView(
          product: product,
        ),
        transition: 'fade');
  }
}
