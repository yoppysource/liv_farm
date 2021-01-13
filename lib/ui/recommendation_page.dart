import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/repository/inventory_repository.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/bottom_float_buttom.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';

class RecommendationPage extends StatelessWidget {
  final List<Product> sideProductList;
  final List<Product> dressingProductList;

  const RecommendationPage(
      {Key key, this.sideProductList, this.dressingProductList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            TitleText(
              text: '샐러드에 프로틴 추가!',
            ),
            SizedBox(
              height: 290,
              child: ProductListView(
                productList: sideProductList,
              ),
            ),
            TitleText(
              text: '드레싱',
            ),
            SizedBox(
              height: 290,
              child: ProductListView(
                productList: dressingProductList,
              ),
            ),
            BottomFloatButton(
              text:  '뒤로 가기',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
  }
}

class ProductListView extends StatelessWidget with Formatter {
  final List<Product> productList;

  const ProductListView({Key key, this.productList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (productList.isEmpty) {
      return Container();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: productList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Product product= productList[index];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (context) => ProductDescriptionViewmodel(
                          product: product,
                       ),
                      child: ProductDescriptionPage(
                      ))));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Container(
            width: 150,
            child: Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: 'img',
                        child: Image.network(
                          '${productList[index].imagePath}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${productList[index].productName}',
                            ),
                            Text('${productList[index].productLocation}'),
                            Text(
                              '${getPriceFromInt(productList[index].productPrice)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.8)),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        icon: Icon(FontAwesomeIcons.cartPlus,
                            size: 20,
                            color: Color(kMainColor).withOpacity(0.7)),
                        onPressed: () async {
                          int inventory = await InventoryRepository().getInventoryNum(productList[index].id);
                          Provider.of<ShoppingCartViewmodel>(context,listen: false).addProduct(Product.copy(productList[index]), Provider.of<LandingPageViewModel>(context,listen: false).user.id, inventory);
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildProductCard(Product product, BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: GestureDetector(
  //       onTap: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => ProductDescriptionPage(
  //                       product: product,
  //                     )));
  //       },
  //       child: Column(
  //         children: [
  //           ClipRRect(
  //             child: SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.1,
  //               child: Image.network(
  //                 '${product.imagePath}',
  //                 fit: BoxFit.fill,
  //               ),
  //             ),
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           Text(
  //             '${product.productName}',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w700,
  //                 color: Colors.black.withOpacity(0.8)),
  //           ),
  //           Text('${product.productLocation}'),
  //           Text('${getPriceFromInt(product.productPrice)}'),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
