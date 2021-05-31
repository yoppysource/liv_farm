import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/item.dart';
import 'package:liv_farm/ui/home/shopping_cart/delivery_information/delivery_information_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/delivery_reservation/delivery_reservation_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/information_about_company_card.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/my_icons_icons.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class ShoppingCartView extends StatelessWidget with Formatter {
  const ShoppingCartView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShoppingCartViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
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
          : Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0.3,
                title: GestureDetector(
                  onTap: model.onPressedAddress,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.location,
                          size: 20,
                          color: kMainGrey,
                        ),
                        horizontalSpaceSmall,
                        Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              model.selectedAddress == null
                                  ? "주소를 선택해주세요"
                                  : '${model.selectedAddress.address} ${model.selectedAddress.addressDetail == null ? "" : model.selectedAddress.addressDetail.length > 7 ? "" : model.selectedAddress.addressDetail}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: kMainBlack),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        horizontalSpaceTiny,
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: kMainPink.withOpacity(0.95),
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: horizontalPaddingToScaffold,
                    child: ListView(
                      children: [
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
                        MyCard(
                          title: '영수증',
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '상품 금액',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            color: kMainGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    getPriceFromInt(model.totalPrice),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            color: kMainBlack,
                                            fontSize: 18,
                                            letterSpacing: 0.7),
                                  ),
                                ],
                              ),
                              verticalSpaceSmall,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '할인 금액',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            color: kMainGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    getPriceFromInt(model.discountAmount),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            color: kMainBlack,
                                            fontSize: 18,
                                            letterSpacing: 0.7),
                                  ),
                                ],
                              ),
                              verticalSpaceSmall,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '배송비',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            color: kMainGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    '무료배송',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            color: kMainBlack,
                                            fontSize: 18,
                                            letterSpacing: 0.7),
                                  ),
                                ],
                              ),
                              verticalSpaceSmall,
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: kMainLightPink.withOpacity(0.95),
                              ),
                              verticalSpaceSmall,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '결제 금액',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            color: kMainGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    getPriceFromInt(model.finalPrice),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            color: kMainBlack,
                                            fontSize: 18,
                                            letterSpacing: 0.7),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceRegular,
                        CouponCard(
                          model: model,
                        ),
                        verticalSpaceRegular,
                        DeliveryInformationView(),
                        verticalSpaceRegular,
                        MyCard(
                          title: '배송지 정보',
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '주소',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              verticalSpaceSmall,
                              GestureDetector(
                                onTap: model.onPressedAddress,
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: kMainPink.withOpacity(0.95),
                                        width: 0.50),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                model.selectedAddress == null
                                                    ? "주소를 선택해주세요"
                                                    : '${model.selectedAddress.address} ${model.selectedAddress.addressDetail == null ? "" : model.selectedAddress.addressDetail.length > 7 ? "" : model.selectedAddress.addressDetail}',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                            child: Icon(
                                              CupertinoIcons.location,
                                              size: 25,
                                              color:
                                                  kMainPink.withOpacity(0.95),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              verticalSpaceSmall,
                            ],
                          ),
                        ),
                        verticalSpaceRegular,
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
                    child: ClipRRect(
                      borderRadius: bottomButtonBorderRadius,
                      child: Container(
                        height: 80,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '결제 금액',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                  color: kMainGrey,
                                                  fontSize: 18),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          getPriceFromInt(model.finalPrice),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                  color: kMainBlack,
                                                  fontSize: 18,
                                                  letterSpacing: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: FlatButton(
                                      height: 50,
                                      color: model.isPossibleToPurchase
                                          ? kMainColor
                                          : kMainGrey.withOpacity(0.8),
                                      child: FittedBox(
                                        child: Text(
                                          model.purchaseButtonMessage,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white,
                                                  fontSize: 19),
                                        ),
                                      ),
                                      onPressed: model.isPossibleToPurchase
                                          ? model.onPressedOnPayment
                                          : () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: kMainBlack,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
      viewModelBuilder: () => locator<ShoppingCartViewModel>(),
    );
  }
}

class DeliveryDateCard extends StatelessWidget {
  final ShoppingCartViewModel model;

  const DeliveryDateCard({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: '배송선택',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '언제 배송을 받아보시겠어요?',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          verticalSpaceSmall,
          DeliveryReservationView(),
          verticalSpaceSmall,
          verticalSpaceSmall,
          Text(
            '배송 시 요청사항이 있으신가요?',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          verticalSpaceSmall,
          GestureDetector(
            onTap: model.callBottomSheetToGetInput,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: kMainPink.withOpacity(0.95), width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            model.deliveryRequest == ''
                                ? '예) 문 앞에 두고 가주세요'
                                : model.deliveryRequest,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: Center(
                        child: Icon(
                          Icons.edit,
                          size: 25,
                          color: kMainPink.withOpacity(0.95),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final ShoppingCartViewModel model;

  const CouponCard({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: '쿠폰',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
                color: kMainColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38, width: 0.2)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          model.selectedCoupon == null
                              ? '쿠폰을 선택해주세요'
                              : model.selectedCoupon.description ?? "할인쿠폰",
                          style: TextStyle(fontSize: 14, color: kMainGrey),
                        ),
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  FlatButton(
                      color: Colors.white,
                      child: Text(
                        '선택',
                        style: TextStyle(color: kMainBlack),
                      ),
                      onPressed: model.onPressedCouponSelect,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: kMainGrey,
                              width: 0.3,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5))),
                ],
              ),
            ),
          ),
          verticalSpaceTiny,
          model.showCouponAlert
              ? Text(
                  "상품금액이 할인 금액보다 더 커야합니다.",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.red),
                )
              : Container()
        ],
      ),
    );
  }
}

class ItemListTile extends StatelessWidget with Formatter {
  final ShoppingCartViewModel model;
  final Item item;

  const ItemListTile({Key key, this.model, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: kSmallBorderRadius,
              child: Container(
                color: Colors.white,
                width: 80,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: item.product.thumbnailPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  horizontalSpaceRegular,
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            item.product.name,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Text(
                          getPriceFromInt(item.product.price),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(color: kMainGrey, letterSpacing: 0.7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            horizontalSpaceTiny,
            Container(
              height: 100,
              width: 90,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          padding: EdgeInsets.zero,
                          iconSize: 30,
                          splashRadius: 20,
                          disabledColor: kMainGrey.withOpacity(0.7),
                          color: kMainPink.withOpacity(0.95),
                          onPressed: item.quantity > 1
                              ? () {
                                  model.decreaseItemQuantity(item);
                                }
                              : null,
                        ),
                      ),
                    ),
                    horizontalSpaceTiny,
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: Text(
                          item.quantity.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(color: kMainGrey),
                        ),
                      ),
                    ),
                    horizontalSpaceTiny,
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          padding: EdgeInsets.zero,
                          iconSize: 30,
                          splashRadius: 20,
                          color: kMainPink.withOpacity(0.95),
                          onPressed: () async {
                            await model.increaseItemQuantity(item);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
              width: 25.0,
              child: IconButton(
                onPressed: () async {
                  await model.removeFromCart(item);
                },
                padding: EdgeInsets.all(0.0),
                icon: Icon(
                  Icons.delete_outlined,
                  size: 25.0,
                  color: kMainGrey,
                ),
              ),
            ),
          ],
        ),
        verticalSpaceSmall,
      ],
    );
  }
}
