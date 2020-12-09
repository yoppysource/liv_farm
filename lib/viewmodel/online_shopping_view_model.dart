import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/repository/online_shopping_repository.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/platform_exception_alert_dialog.dart';

class OnlineShoppingViewmodel with ChangeNotifier {
  List<Product> productList;
OnlineShoppingRepository _repository = OnlineShoppingRepository();

OnlineShoppingViewmodel() {}
  Future<void> init() async {
    productList = await _repository.fetchProductListFromServer();
    notifyListeners();
  }

  Future<void> onPressed(BuildContext context) async {
  await init();
    print('${productList.toString()}');
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 100000),
      content: Container(height: 10),
      behavior: SnackBarBehavior.floating, // Add this line
    ));
  }
}
