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
      //TODO: purchase Fetch
      for (Purchase purchase in purchaseList) {
        List<Product> productListWithQuantity = List();
        //TODO: purchase정보가지고 cart_items_cart에 엔드포인트에서 id와 quantity추출
        Map productIdPairedWithQuantity =
            await _repository.fetchProductIdPairedWithQuantity(purchase);
        if (productIdPairedWithQuantity == null) {
          print('nul');
          return null;
        }
        for (int key in productIdPairedWithQuantity.keys) {
          //TODO: 아이디를 가지고 prouductList에서 프로덕트 매칭후에 quantity 넣어주기.
          for (Product product in productList) {
            if (key == product.id) {
              Product currentProduct = product;
              print('${productIdPairedWithQuantity[key]}');
              currentProduct.productQuantity = productIdPairedWithQuantity[key];
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
