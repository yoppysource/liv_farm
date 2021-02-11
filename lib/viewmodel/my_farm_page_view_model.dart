import 'package:flutter/cupertino.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/repository/my_farm_page_repository.dart';
import 'package:liv_farm/temp/logger.dart';

class MyFarmPageViewModel with ChangeNotifier {
  List<Purchase> purchaseList;
  bool isLoading;
  List<int> orderCountList;
  // MyUser user;
  MyUser user;

  MyFarmPageRepository _repository = MyFarmPageRepository();

  MyFarmPageViewModel(myUser) {
    this.user = myUser;
    init();
    log.methodLog(method: 'FarmPage Init');
  }

  Future<void> init() async {
    log.methodLog(method: 'Init');
    purchaseList = await _repository.fetchPurchaseData(user.id);
    if (purchaseList != null && purchaseList.isNotEmpty) {
      orderCountList = [0, 0, 0, 0, 0];
      for (Purchase purchase in purchaseList) {
        if(purchase.purchaseStatus != null)
        orderCountList[purchase.purchaseStatus] += 1;

      }
    } else if (purchaseList.isEmpty) {
      orderCountList = [0, 0, 0, 0, 0];
    }

    notifyListeners();
  }
  void updateUser(MyUser user) {
    this.user = user;
    notifyListeners();
  }
}
