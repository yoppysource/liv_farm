import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/shopping_cart/component/address_card.dart';
import 'package:liv_farm/ui/home/shopping_cart/component/cart_item_list_tile.dart';
import 'package:liv_farm/ui/home/shopping_cart/component/coupon_card.dart';
import 'package:liv_farm/ui/home/shopping_cart/component/delivery_date_card.dart';
import 'package:liv_farm/ui/home/shopping_cart/component/delivery_option_card.dart';
import 'package:liv_farm/ui/home/shopping_cart/component/purchase_button_bar.dart';
import 'package:liv_farm/ui/home/shopping_cart/component/receipt_card.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/address_appbar/address_appbar_view.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/information_about_company_card.dart';
import 'package:liv_farm/ui/shared/my_icons_icons.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:stacked/stacked.dart';

import 'delivery_information/delivery_information_view.dart';

class ShoppingCartView extends StatelessWidget with Formatter {
  const ShoppingCartView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShoppingCartViewModel>.reactive(
      viewModelBuilder: () => ShoppingCartViewModel(),
      builder: (context, model, child) => model.cartLength == 0
          ? Scaffold(
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MyIcons.shopping_cart,
                      color: kMainGrey,
                      size: 80,
                    ),
                    verticalSpaceRegular,
                    Text(
                      '카트가 비어 있습니다',
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: kMainGrey, fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            )
          : LoadingOverlay(
              isLoading: model.isBusy,
              progressIndicator: CircularProgressIndicator(),
              child: Scaffold(
                  appBar: PreferredSize(child:  AddressAppBarView(), preferredSize: new Size.fromHeight(50),),
                  body: Stack(
                    children: [
                      Padding(
                        padding: horizontalPaddingToScaffold,
                        child: ListView(
                          children: [
                            if(model.showBannerText)
                            Container(height: 30,color: Colors.white, child: Center(child: Text(model.bannerText, style: TextStyle(color: kSubColor.withOpacity(0.9),),),),),
                            verticalSpaceRegular,
                            Column(
                              children: model.cart.items
                                  .map(
                                    (item) =>
                                        ItemListTile(model: model, item: item),
                                  )
                                  .toList(),
                            ),
                            //default padding is 25, and padding on listTile  = 18  Thus, 7
                            SizedBox(height: 8),
                            verticalSpaceRegular,
                            CouponCard(
                              model: model,
                            ),
                            verticalSpaceRegular,
                            ReceiptCard(model: model),
                            verticalSpaceRegular,
                            DeliveryInformationView(),
                            verticalSpaceRegular,
                            if(model.store.takeOut)
                            Column(
                              children: [
                                DeliveryOptionCard(model: model,),
                                 verticalSpaceRegular,
                              ],
                            ),
                            if(!model.takeOut)
                            Column(
                              children: [
                                AddressCard(
                                  model: model,
                                ),
                                 verticalSpaceRegular,
                              ],
                            ),
                     
                            DeliveryDateCard(
                              model: model,
                            ),
                            verticalSpaceRegular,
                            InformationAboutCompanyCard(),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: PurchaseButtonBar(
                          model: model,
                        ),
                      )
                    ],
                  )),
            ),
    );
  }
}
