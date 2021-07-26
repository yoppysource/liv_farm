import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/styles.dart';

import '../shopping_cart_viewmodel.dart';

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
                  imageUrl: item.inventory.product.thumbnailPath,
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
                            item.inventory.product.name,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Text(
                          getPriceFromInt(item.inventory.product.price),
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
