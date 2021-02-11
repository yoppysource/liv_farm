import 'package:flutter/foundation.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/repository/payment_repository.dart';
import 'package:liv_farm/service/analytic_service.dart';
import 'package:liv_farm/utill/get_it.dart';

class PaymentViewModel with ChangeNotifier {
  final Purchase purchase;
  final int totalAmount;
  final PaymentRepository _repository = PaymentRepository();
  bool isBusy = false;
  PaymentViewModel({@required this.purchase, @required this.totalAmount});

  Future<bool> onPressedCallBack(Map<String, String> result) async {
    isBusy = true;
    notifyListeners();
    await locator<AnalyticsService>().logPurchase(totalValue: totalAmount.toDouble(), couponId: '쿠폰', address: purchase.deliveryAddress);
    if (result['imp_success'] == 'true') {
      try{
      await _repository.postPurchase(this.purchase);
      // Future.wait([
      //   _repository.updateCartsWhenPurchased(data: {
      //     KEY_amountPriceForCart: this.totalAmount, KEY_cartStatus: 1
      //   }, cartId: purchase.cartId),
      //   _repository.postPurchase(this.purchase),
      // ]);
        ;}
      catch(e){
        isBusy = false;
        notifyListeners();
        return false;
      }
      isBusy = false;
      notifyListeners();
      return true;
    } else {
      isBusy = false;
      notifyListeners();
      return false;
    }
  }
}
