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
          padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
          child: Stack(
            children: [
              Card(
                color: Colors.white,
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: CachedNetworkImage(
                        imageUrl: productList[index].thumbnailPath,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fadeInDuration: Duration(milliseconds: 50),
                        fit: isOneItemForRow ? BoxFit.fitWidth : BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                verticalSpaceTiny,
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${productList[index].name}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            color: Color(0xff333333),
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                  ),
                                ),
                                verticalSpaceTiny,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${getPriceFromInt(productList[index].price)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              letterSpacing: 0.7),
                                    ),
                                    Text(
                                      '${productList[index].weight}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                    ),
                                  ],
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
              if (productList[index].inventory == 0)
                Container(
                  color: Colors.grey.withOpacity(0.2),
                ),
              if (productList[index].inventory == 0)
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 40,
                        child: Image.asset(
                          'assets/images/growing_icon.png',
                          color: Colors.black.withOpacity(0.6),
                        )),
                  ),
                )
              // if (productList[index].inventory == 0)
              //   Align(
              //     alignment: Alignment.topLeft,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Row(
              //         children: [
              //           Text(
              //             '재배 중인 상품입니다',
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .bodyText2
              //                 .copyWith(fontSize: 14),
              //           )
              //         ],
              //       ),
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
