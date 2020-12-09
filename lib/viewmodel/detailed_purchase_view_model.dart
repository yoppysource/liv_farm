import 'package:flutter/foundation.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/repository/my_farm_page_repository.dart';

class DetailedPurchaseViewmodel with ChangeNotifier {
  bool isBusy = true;
  MyFarmPageRepository _repository = MyFarmPageRepository();
  Map<Purchase, List<Product>> purchasePairedWithProductList;

  DetailedPurchaseViewmodel(purchaseList, productList) {
    init(purchaseList, productList);
  }

  Future init(List<Purchase> purchaseList, List<Product> productList) async {
    purchasePairedWithProductList = Map();
    try {
      for (Purchase purchase in purchaseList) {
        List<Product> productListWithQuantity = List();
        Map productIdPairedWithQuantity =
            await _repository.fetchProductIdPairedWithQuantity(purchase);
        if (productIdPairedWithQuantity == null) {
          print('nul');
          return null;
        }
        for (int key in productIdPairedWithQuantity.keys) {
          for (Product product in productList) {
            if (key == product.id) {
              Product currentProduct = product;
              print('${productIdPairedWithQuantity[key]}');
              currentProduct.quantity = productIdPairedWithQuantity[key];
              productListWithQuantity.add(currentProduct);
            }
          }
        }
        purchasePairedWithProductList[purchase] = productListWithQuantity;
      }
      isBusy = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
