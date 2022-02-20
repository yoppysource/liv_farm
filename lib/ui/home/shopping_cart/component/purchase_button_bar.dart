import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class PurchaseButtonBar extends StatelessWidget with Formatter {
  final ShoppingCartViewModel model;

  const PurchaseButtonBar({Key? key, required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: bottomButtonBorderRadius,
      child: Container(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '결제 금액',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: kMainGrey, fontSize: 18),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          getPriceFromInt(model.paymentAmount),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
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
                              .subtitle2!
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
        decoration: const BoxDecoration(
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
    );
  }
}
