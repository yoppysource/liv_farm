import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/ui/online_shopping_page/my_drawer.dart';
import 'package:liv_farm/ui/payment_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';
import 'package:liv_farm/ui/shopping_cart_page/cart_list_tile.dart';
import 'package:liv_farm/ui/user_input_page/delivery_information_input_page.dart';
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
      drawer: MyDrawer(),
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
                        : '배송정보 입력하기'),
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
                              itemCount: _model.shoppingCart.length+2,
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
                                    product: _model.shoppingCart[index - 1]);
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ListTile(
                        title: Text('상품 금액'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        trailing: Text(getPriceFromInt(_model.totalPrice)),
                      ),
                      ListTile(
                        title: Text('프로모션'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        trailing: Text('0원'),
                      ),
                      ListTile(
                        title: Text('배송비'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        trailing: Text(
                            getPriceFromInt(_model.deliveryFee).toString()),
                      ),
                      Container(
                        height: 0.2,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(color: Colors.black54),
                      ),
                      ListTile(
                        title: Text('총 금액'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        trailing: Text(getPriceFromInt(_model.totalAmount)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: FlatButton(
                disabledColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color(kMainColor),
                child: Text(
                  _model.isInformationAvailable
                      ? _model.totalAmount == 0
                          ? '물품을 담아주세요'
                          : '결제하기'
                      : '배송 정보를 입력해주세요',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _model.isInformationAvailable
                    ? _model.totalAmount == 0
                        ? null
                        : () async {
                            Purchase purchase = _model.createPurchaseData();
                            bool isSuccess = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider<PaymentViewModel>(
                                    create: (context) => PaymentViewModel(
                                        purchase: purchase,
                                        totalAmount: _model.totalAmount),
                                    child: PaymentPage(),
                                  ),
                                ));
                            if (isSuccess) {
                              _model.clearCart();
                              ToastMessage().showPurchaseSuccessToast();
                            } else {
                              ToastMessage().showPurchaseFailToast();
                            }
                          }
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
