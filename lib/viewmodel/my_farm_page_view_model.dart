import 'package:flutter/cupertino.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/repository/my_farm_page_repository.dart';

class MyFarmPageViewModel with ChangeNotifier {
  List<Purchase> purchaseList;
  bool isLoading;
  List<int> orderCountList;
  MyUser user;

  MyFarmPageRepository _repository = MyFarmPageRepository();

  MyFarmPageViewModel(myUser) {
    this.user = myUser;
    init();
  }

  Future<void> init() async {
   purchaseList = await _repository.fetchPurchaseData(user.id);
   if(purchaseList !=null && purchaseList.isNotEmpty){
     orderCountList = [0,0,0,0,0];
     for (Purchase purchase in purchaseList){
       orderCountList[purchase.purchaseStatus] += 1;
     }
   } else if(purchaseList.isEmpty){
     orderCountList = [0,0,0,0,0];
   }
   notifyListeners();
  }
}