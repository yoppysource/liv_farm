import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/home/farm/farm_viewmodel.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class ProductGridView extends StatelessWidget with Formatter {
  final List<Product> productList;
  final FarmViewModel model;

  const ProductGridView({Key key, this.productList, this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOneItemForRow = productList.length < 4;

    return GridView.builder(
      itemCount: productList.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: isOneItemForRow ? 1 : 0.5,
          crossAxisCount: isOneItemForRow ? 1 : 2),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          model.onProductTap(productList[index]);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Card(
            color: kMainIvory,
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: productList[index].thumbnailPath,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fadeInDuration: Duration(milliseconds: 50),
                      fit: isOneItemForRow ? BoxFit.fitWidth : BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${productList[index].name}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '${getPriceFromInt(productList[index].price)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.6),
                                      letterSpacing: 0.7),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
