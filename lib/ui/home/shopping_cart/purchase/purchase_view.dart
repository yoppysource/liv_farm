import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:liv_farm/model/order.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/ui/home/shopping_cart/purchase/purchase_viewmodel.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:stacked/stacked.dart';

class PurchaseView extends StatelessWidget {
  final PaymentData paymentData;
  final Order order;

  const PurchaseView({Key? key, required this.paymentData, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PurchaseViewModel>.reactive(
      builder: (context, model, child) => LoadingOverlay(
        isLoading: model.isBusy,
        color: kMainGrey,
        progressIndicator: const CircularProgressIndicator(),
        child: IamportPayment(
            appBar: AppBar(
              title: Text(
                '결제하기',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              leading: GestureDetector(
                child: kArrowBack,
                onTap: model.onPressedArrowBack,
              ),
            ),
            /* 웹뷰 로딩 컴포넌트 */
            initialChild: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child: Text('잠시만 기다려주세요...',
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ],
              ),
            ),
            /* [필수입력] 가맹점 식별코드 */
            userCode: KEY_IamPort,
            /* [필수입력] 결제 데이터 */
            data: paymentData,
            /* [필수입력] 콜백 함수 */
            callback: model.callback),
      ),
      viewModelBuilder: () => PurchaseViewModel(paymentData, order),
    );
  }
}
