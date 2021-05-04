import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';

import 'package:liv_farm/ui/shared/bottom_sheet/add_to_cart_bottom_sheet/add_to_cart_bottom_sheet_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../styles.dart';

class AddToCartBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const AddToCartBottomSheetView({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddToCartBottomSheetViewModel>.reactive(
      viewModelBuilder: () =>
          AddToCartBottomSheetViewModel(request.customData['productList']),
      builder: (context, model, child) => GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: model.mapProductToQuantity.entries.map((entry) {
                    return CartListTile(product: entry.key, model: model);
                  }).toList(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () =>
                            completer(SheetResponse(confirmed: false)),
                        child: Text(
                          '뒤로가기',
                          style: TextStyle(color: kMainPink, fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FullScreenButton(
                        title: '장바구니에 담기',
                        color: kMainPink,
                        onPressed: () => completer(SheetResponse(
                            confirmed: true,
                            responseData: model.mapProductToQuantity)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartListTile extends StatelessWidget with Formatter {
  final Product product;
  final AddToCartBottomSheetViewModel model;

  const CartListTile({Key key, this.product, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              product.name,
              style: TextStyle(fontSize: 25, color: kMainGrey),
            )),
        verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  getPriceFromInt(product.price),
                  style: TextStyle(fontSize: 22, color: kMainGrey),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: kMainGrey),
                borderRadius: BorderRadius.circular(5),
              ),
              height: 40,
              width: 120,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(CupertinoIcons.minus),
                    padding: EdgeInsets.zero,
                    iconSize: 22,
                    onPressed: () => model.subtractQuantity(product),
                  ),
                  Container(
                    width: 20,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        model.mapProductToQuantity[product].toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: kMainGrey, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(CupertinoIcons.add),
                      padding: EdgeInsets.only(left: 5),
                      iconSize: 25,
                      onPressed: () => model.addQuantity(product),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpaceLarge,
      ],
    );
  }
}

//
//               verticalSpaceMedium,
//
