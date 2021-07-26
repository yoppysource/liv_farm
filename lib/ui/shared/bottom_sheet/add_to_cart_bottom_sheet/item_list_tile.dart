import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/add_to_cart_bottom_sheet/add_to_cart_bottom_sheet_viewmodel.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class ItemListTile extends StatelessWidget with Formatter {
  final Inventory inventory;
  final AddToCartBottomSheetViewModel model;

  const ItemListTile({Key key, this.inventory, this.model}) : super(key: key);
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
              inventory.product.name,
              style: TextStyle(fontSize: 21, color: kMainGrey),
            ),
            if (inventory.product.category == ProductCategory.Dressing ||
                inventory.product.category == ProductCategory.Protein)
              GestureDetector(
                onTap: () {
                  model.navigateToProductDetail(inventory);
                },
                child: Row(
                  children: [
                    Text('상세보기'),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: kMainGrey,
                    )
                  ],
                ),
              )
          ],
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
                  getPriceFromInt(inventory.product.price),
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
                    onPressed: () => model.subtractQuantity(inventory),
                  ),
                  Container(
                    width: 20,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        model.mapInventoryToQuantity[inventory].toString(),
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
                      onPressed: () => model.addQuantity(inventory),
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
