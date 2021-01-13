import 'package:flutter/material.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/product_description_page/add_bottom_sheet.dart';

import 'package:liv_farm/ui/product_description_page/basic_description_page.dart';
import 'package:liv_farm/ui/product_description_page/bottom_tab_bar.dart';

import 'package:liv_farm/ui/recommendation_page.dart';
import 'package:liv_farm/ui/shared/buttons/bottom_float_buttom.dart';
import 'package:liv_farm/viewmodel/add_bottom_sheet_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';

import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductDescriptionPage extends StatefulWidget {
  @override
  _ProductDescriptionPageState createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage>
    with SingleTickerProviderStateMixin, Formatter {
  int selectedIndex = 0;

  @override
  void initState() {
    if (mounted) {
      Provider.of<ProductDescriptionViewmodel>(context, listen: false)
          .lazyLoad();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductDescriptionViewmodel _model =
        Provider.of<ProductDescriptionViewmodel>(context, listen: true);
    Product product = _model.product;
    ShoppingCartViewmodel _shoppingCartViewModel =
        Provider.of<ShoppingCartViewmodel>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              BasicDescriptionPage(
                product: product,
                inventory:
                    _model.isLazyLoaded == false ? null : _model.inventory,
              ),
              BottomTabBar(
                tabs: [
                  Tab(
                    child: Text(
                      '상세정보',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      '리뷰(${_model.isLazyLoaded == false ? '' : _model.reviewList.length})',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          if (_model.isLazyLoaded == true && !(_model.product.productCategory ==9 || _model.product.productCategory ==10))
            BottomFloatButton(
              text: _model.inventory <= 0 ? '품절된 상품 입니다.' : '장바구니에 담기',
              onPressed: _model.inventory <= 0
                  ? null
                  : () async {
                List<Product> temp = await showBarModalBottomSheet(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.5),
                  shape: Border.all(width: 0.0),
                  expand: false,
                  builder: (context) => ChangeNotifierProvider<AddBottomSheetViewModel>(
                    create: (context) => AddBottomSheetViewModel(
                      productList: Provider.of<OnlineShoppingViewmodel>(context,listen: false).productList,
                      selectedProduct: Product.copy(_model.product),
                    ),
                    child: AddBottomSheet(),
                  ),
                );
                      if (temp != null) {
                        temp.forEach((element)async {
                          await _shoppingCartViewModel.addProduct(
                              element,
                              Provider.of<LandingPageViewModel>(context,
                                  listen: false)
                                  .user
                                  .id,
                              _model.inventory);
                        });
                        Navigator.pop(context);
                        // if (product.productCategory == 1)
                        //   await showBarModalBottomSheet(
                        //     expand: false,
                        //     context: context,
                        //     builder: (context) => RecommendationPage(
                        //       sideProductList:
                        //           Provider.of<OnlineShoppingViewmodel>(context,
                        //                   listen: false)
                        //               .productList
                        //               .where((element) =>
                        //                   element.productCategory == 9)
                        //               .toList(),
                        //       dressingProductList:
                        //           Provider.of<OnlineShoppingViewmodel>(context,
                        //                   listen: false)
                        //               .productList
                        //               .where((element) =>
                        //                   element.productCategory == 10)
                        //               .toList(),
                        //     ),
                        //   );
                      }
                    },
            ),
        ],
      ),
    );
  }
}

class LargeText extends StatelessWidget {
  final String text;

  const LargeText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 17, color: Colors.black87),
    );
  }
}

class SmallText extends StatelessWidget {
  final String text;

  const SmallText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 14,
      ),
    );
  }
}
