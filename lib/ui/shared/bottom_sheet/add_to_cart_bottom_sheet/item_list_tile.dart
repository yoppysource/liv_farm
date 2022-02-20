import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:liv_farm/ui/shared/bottom_sheet/add_to_cart_bottom_sheet/add_to_cart_bottom_sheet_viewmodel.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class ItemListTile extends StatelessWidget with Formatter {
  final AddToCartBottomSheetViewModel model;

  const ItemListTile({Key? key, required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              model.item.inventory.product.name,
              style: const TextStyle(fontSize: 21, color: kMainGrey),
            ),
          ],
        ),
        SizedBox(
          height: 25,
          child: Text(model.optionText),
        ),
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
                  getPriceFromInt(model.price),
                  style: const TextStyle(fontSize: 22, color: kMainGrey),
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
                    icon: const Icon(CupertinoIcons.minus),
                    padding: EdgeInsets.zero,
                    iconSize: 22,
                    onPressed: () => model.subtractQuantity(),
                  ),
                  SizedBox(
                    width: 20,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        model.item.quantity.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: kMainGrey, fontSize: 20),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.add),
                    padding: const EdgeInsets.only(left: 5),
                    iconSize: 25,
                    onPressed: () => model.addQuantity(),
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
