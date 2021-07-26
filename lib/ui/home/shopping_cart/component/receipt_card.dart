import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class ReceiptCard extends StatelessWidget with Formatter {
  final ShoppingCartViewModel model;

  const ReceiptCard({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: '영수증',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '상품 금액',
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: kMainGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                getPriceFromInt(model.totalPrice),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: kMainBlack, fontSize: 18, letterSpacing: 0.7),
              ),
            ],
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '할인 금액',
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: kMainGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                getPriceFromInt(model.discountAmount),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: kMainBlack, fontSize: 18, letterSpacing: 0.7),
              ),
            ],
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '배송비',
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: kMainGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                '무료배송',
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: kMainBlack, fontSize: 18, letterSpacing: 0.7),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '결제 금액',
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: kMainGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                getPriceFromInt(model.finalPrice),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: kMainBlack, fontSize: 18, letterSpacing: 0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
