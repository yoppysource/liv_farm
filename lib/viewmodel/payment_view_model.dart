import 'package:flutter/foundation.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/repository/coupon_repository.dart';
import 'package:liv_farm/repository/payment_repository.dart';
import 'package:liv_farm/service/analytic_service.dart';
import 'package:liv_farm/ui/payment_page.dart';
import 'package:liv_farm/utill/get_it.dart';

class PaymentViewModel with ChangeNotifier {
  final Purchase purchase;
  final int totalAmount;
  final int cartID;
  final Coupon coupon;
  final PaymentRepository _repository = PaymentRepository();
  final CouponRepository _couponRepository = CouponRepository();
  bool isBusy = false;
  PaymentViewModel({@required this.purchase,@required this.cartID,this.coupon, @required this.totalAmount});

  Future<PaymentResult> onPressedCallBack(Map<String, String> result) async {
    print(result);
    isBusy = true;
    notifyListeners();
    await locator<AnalyticsService>().logPurchase(totalValue: totalAmount.toDouble(), couponId: coupon.couponID, address: purchase.deliveryAddress);
    await _couponRepository.usedCoupon(coupon.couponID);
    if (result['imp_success'] == 'true') {
      Map data = await _repository.postPurchase(this.purchase);
      if(data[MSG] ==MSG_fail) {
        return PaymentResult.PaidButNotUpload;
      }
      isBusy = false;
      notifyListeners();
      return PaymentResult.Success;
    } else {
      isBusy = false;
      notifyListeners();
      return PaymentResult.NotPaid;
    }
  }
}
