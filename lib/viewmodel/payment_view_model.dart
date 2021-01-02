import 'package:flutter/foundation.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/repository/payment_repository.dart';

class PaymentViewModel with ChangeNotifier {
  final Purchase purchase;
  final int totalAmount;
  final PaymentRepository _repository = PaymentRepository();
  bool isBusy = false;
  PaymentViewModel({@required this.purchase, @required this.totalAmount});

  Future<bool> onPressedCallBack(Map<String, String> result) async {
    isBusy = true;
    notifyListeners();
    print(result);
    if (result['imp_success'] == 'true') {
      await Future.wait([
        _repository.updateCartsWhenPurchased(data: {
          KEY_amountPriceForCart: this.totalAmount, KEY_cartStatus: 1
        }, cartId: purchase.cartId),
        _repository.postPurchase(this.purchase),
      ]);
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
