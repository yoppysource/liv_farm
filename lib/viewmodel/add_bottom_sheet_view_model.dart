import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/repository/inventory_repository.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';

class AddBottomSheetViewModel with ChangeNotifier {
  List<Product> toppingProductList;
  List<Product> dressingProductList;
  final Product selectedProduct;

  List<Product> resultList = [];

  int get totalPrice {
    int temp = 0;
    toppingProductList.forEach((element) {
      temp += element.productPrice * element.productQuantity;
    });
    dressingProductList.forEach((element) {
      temp += element.productPrice * element.productQuantity;
    });
    temp += selectedProduct.productQuantity * selectedProduct.productPrice;

    return temp;
  }

  final InventoryRepository _repository = InventoryRepository();

  AddBottomSheetViewModel(
      {@required List<Product> productList, @required this.selectedProduct}) {
    this.toppingProductList =
        productList.where((element) => element.productCategory == 9).map((e) {
      Product temp = Product.copy(e);
      temp.productQuantity = 0;
      return temp;
    }).toList();
    this.dressingProductList =
        productList.where((element) => element.productCategory == 10).map((e) {
          Product temp = Product.copy(e);
          temp.productQuantity = 0;
          return temp;
        }).toList();
  }

  Future<void> addQuantity(Product product) async {
    int inventory = await _repository.getInventoryNum(product.id);

    if (inventory <= product.productQuantity) {
      ToastMessage().showInventoryErrorToast();
      return;
    } else {
      product.productQuantity++;
      notifyListeners();
    }
  }

  void removeQuantity(Product product) {
    if (product.productQuantity >= 2) {
      product.productQuantity--;
      notifyListeners();
    }
  }

  List<Product> onPressed() {
    if(selectedProduct.productQuantity != 0){
      resultList.add(this.selectedProduct);
    }
    toppingProductList.forEach((element) {
      if(element.productQuantity != 0)
        resultList.add(element);
    });
    dressingProductList.forEach((element) {
      if(element.productQuantity != 0)
        resultList.add(element);
    });

    return resultList;

  }
}
