import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/ui/my_farm_page/coupon_page/coupon_page.dart';
import 'package:liv_farm/ui/payment_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/bottom_float_buttom.dart';
import 'package:liv_farm/ui/shared/information_about_company_card.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/platform_widget/my_text_field.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';
import 'package:liv_farm/ui/shopping_cart_page/cart_list_tile.dart';
import 'package:liv_farm/ui/user_input_page/delivery_information_input_page.dart';
import 'package:liv_farm/viewmodel/coupon_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/my_farm_page_view_model.dart';
import 'package:liv_farm/viewmodel/payment_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:liv_farm/viewmodel/user_input_page_view_model.dart';
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatelessWidget with Formatter {
  @override
  Widget build(BuildContext context) {
    ShoppingCartViewmodel _model =
        Provider.of<ShoppingCartViewmodel>(context, listen: true);
    return Scaffold(
      appBar: MyAppBar(
        title: '장바구니',
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2,
                ),
                MyCard(
                  child: ListTile(
                    leading: Icon(Icons.location_on_outlined),
                    title: Text(_model.isInformationAvailable
                        ? _model.myUser.address
                        : '배송정보 입력하기', style: Theme.of(context).textTheme.bodyText1,),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<UserInputPageViewModel>(
                            create: (context) => UserInputPageViewModel(
                                Provider.of<MyFarmPageViewModel>(context,
                                    listen: false)),
                            child: DeliveryInformationInputPage(
                              purpose: DeliveryInformationPurpose.purchase,
                            ),
                          ),
                        ),
                      ).then((value) => _model.rebuildWidget());
                    },
                  ),
                ),
                MyCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TitleText(
                        text: '담긴 상품',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _model.shoppingCart.length == 0
                          ? Center(
                              child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 100),
                              child: Text('장바구니가 비어 있습니다.'),
                            ))
                          : ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _model.shoppingCart.length + 2,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                if (index == 0 ||
                                    index == _model.shoppingCart.length + 1) {
                                  // 처음과 끝에 세퍼레이터 추가해주기위해서 컨테이너 블러옴
                                  return Container(
                                    height: 0.5,
                                  );
                                }
                                return CartListTile(
                                    cartItem: _model.shoppingCart[index - 1]);
                              },
                              separatorBuilder: (context, index) => Divider(
                                height: 0.5,
                              ),
                            ),
                    ],
                  ),
                ),
                MyCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      TitleText(
                        text: '쿠폰',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(kMainColor).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.black38, width: 0.2)),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      child: Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Text(
                                          _model.coupon?.description ?? '쿠폰을 선택해주세요',
                                          style: TextStyle(
                                            fontSize: 14,
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: FlatButton(
                                        color: Colors.white,
                                          child: Text(
                                            '선택',
                                            style: TextStyle(
                                                color: Color(kMainColor)),
                                          ),
                                          onPressed: ()async {
                                            Coupon coupon = await Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                                                create: (context) => CouponViewmodel(Provider.of<LandingPageViewModel>(context,listen: false).user.id),
                                                child: CouponPage())));
                                            if(coupon!=null){
                                              _model.applyCoupon(coupon);
                                            }


                                          },
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Color(kMainColor).withOpacity(0.7),
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(5))
                                      ),
                                    )),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                MyCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ListTile(
                        title: Text('상품 금액', style : Theme.of(context).textTheme.bodyText1),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        trailing: Text(getPriceFromInt(_model.totalPrice),),
                      ),
                      ListTile(
                        title: Text('할인 금액', style : Theme.of(context).textTheme.bodyText1),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        trailing: Text(getPriceFromInt(_model.discountAmount)),
                      ),
                      ListTile(
                        title: Text('배송비', style : Theme.of(context).textTheme.bodyText1),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        trailing: Text(
                            getPriceFromInt(_model.deliveryFee).toString()),
                      ),
                      Center(
                        child: Container(
                          height: 0.2,
                          width: MediaQuery.of(context).size.width * 0.93,
                          decoration: BoxDecoration(color: Colors.black54),
                        ),
                      ),
                      ListTile(
                        title: Text('총 금액', style : Theme.of(context).textTheme.bodyText1),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        trailing: Text(getPriceFromInt(_model.totalAmount)),
                      ),
                    ],
                  ),
                ),
                InformationAboutCard(),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
          BottomFloatButton(
            text: _model.isInformationAvailable
                ? _model.totalAmount == 0
                    ? '물품을 담아주세요'
                    : '결제하기'
                : '배송 정보를 입력해주세요',
            onPressed: _model.isInformationAvailable
                ? _model.totalAmount == 0
                    ? null
                    : () async {
                        Purchase purchase = await _model.createPurchaseData();
                        if (purchase == null) {
                          ToastMessage().showPurchaseFailByInventoryToast();
                          return;
                        }
                        PaymentResult paymentResult =
                            await Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              ChangeNotifierProvider<PaymentViewModel>(
                            create: (context) => PaymentViewModel(
                                purchase: purchase,
                                coupon: _model.coupon,
                                cartID: _model.shoppingCartID,
                                totalAmount: _model.totalAmount),
                            child: PaymentPage(),
                          ),
                        ));
                        print(paymentResult);
                        if (paymentResult == PaymentResult.Success) {
                          _model.clearCart();
                          ToastMessage().showPurchaseSuccessToast();
                          await Provider.of<MyFarmPageViewModel>(context,
                                  listen: false)
                              .init();
                        } else if(paymentResult == PaymentResult.PaidButNotUpload) {
                          ToastMessage().showPaidButNotUploaded();

                        } else {
                          ToastMessage().showPurchaseFailToast();
                        }
                      }
                : null,
          ),
        ],
      ),
    );
  }
}
