import 'package:flutter/material.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';

class CartListTile extends StatelessWidget with Formatter {
  final Product product;

  const CartListTile({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShoppingCartViewmodel _model = Provider.of<ShoppingCartViewmodel>(context,listen: false);
    return Container(
      height: 100,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SizedBox(
                height: 100,
                width: 100,
                child: Image.network(
                  product.imagePath,
                  fit: BoxFit.fill,
                )),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                TitleText(
                  text: product.productName,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                TitleText(
                  text: getPriceFromInt(product.productPrice),
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(5),
              ),
              height: 35,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.remove),
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      disabledColor: Colors.transparent,
                      onPressed: product.productQuantity <= 1
                          ? null
                          : () {
                        _model.removeQuantityOfProduct(product);
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${product.productQuantity}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: IconButton(
                        icon: Icon(Icons.add),
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        onPressed: () {
                          _model.addQuantityOfProduct(product);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 0.1,
              icon: Icon(Icons.clear,size: 19,), color: Colors.grey.withOpacity(0.8),
            onPressed: (){
              _model.deleteProduct(product);
            },
            ),
          )),
          // SizedBox(
          //   width: 35,
          //   child: IconButton(
          //     icon: Icon(Icons.delete),
          //     onPressed: () {
          //       _model.deleteProduct(product);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
