import 'package:flutter/material.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';

class BasicDescriptionPage extends StatelessWidget with Formatter {
  final Product product;

  const BasicDescriptionPage({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Hero(
                tag: '${product.id}',
                child: SizedBox(
                    height: MediaQuery.of(context).size.width *
                        0.9 *
                        1.5,
                    width:
                    MediaQuery.of(context).size.width * 1.0,
                    child: Image.network(
                      product.imagePath,
                      fit: BoxFit.cover,
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                SmallText(text: product.productIntro),
                SizedBox(
                  height: 20,
                ),
                LargeText(text: product.productName),
                SmallText(text: product.productNameInEng),
                SizedBox(
                  height: 30,
                ),
                Text(
                  product.productDescription,
                ),
                SizedBox(
                  height: 20,
                ),
                LargeText(
                    text: getPriceFromInt(product.productPrice)),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
