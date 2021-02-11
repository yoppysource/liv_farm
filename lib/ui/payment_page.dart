import 'package:flutter/material.dart';
/* 아임포트 결제 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_payment.dart';
/* 아임포트 결제 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/payment_view_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PaymentViewModel model =
        Provider.of<PaymentViewModel>(context, listen: true);
    MyUser user =
        Provider.of<LandingPageViewModel>(context, listen: false).user;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: ModalProgressHUD(
        inAsyncCall: model.isBusy,
        child: IamportPayment(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            title: Text(
              '결제하기',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconTheme: IconThemeData(color: Colors.black87),
          ),
          /* 웹뷰 로딩 컴포넌트 */
          initialChild: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('결제 화면 이동중입니다.'),
                ],
              ),
            ),
          ),
          /* [필수입력] 가맹점 식별코드 */
          userCode: iamPortNumber,
          /* [필수입력] 결제 데이터 */
          data: PaymentData.fromJson({
            'pg': 'html5_inicis', // PG사
            'payMethod': 'card', // 결제수단
            'name': '아임포트 결제데이터 분석', // 주문명
            'merchantUid':
                'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
            'amount': model.totalAmount, // 결제금액
            'buyerName': user.name, // 구매자 이름
            'buyerTel': user.phoneNumber, // 구매자 연락처
            'buyerEmail': user.email, // 구매자 이메일
            'buyerAddr': model.purchase.deliveryAddress, // 구매자 주소
            'buyerPostcode': user.postCode, // 구매자 우편번호
            'appScheme': 'livFarm', // 앱 URL scheme
            'display': {
              'cardQuota': [2, 3] //결제창 UI 내 할부개월수 제한
            }
          }),
          /* [필수입력] 콜백 함수 */
          callback: (Map<String, String> result) async {
            bool isSuccess = await model.onPressedCallBack(result);
            Navigator.of(context).pop(isSuccess);
          },
        ),
      ),
    );
  }
}
