import 'package:flutter/material.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/product_description_page/add_bottom_sheet.dart';
import 'package:liv_farm/ui/product_description_page/addtional_information_page.dart';
import 'package:liv_farm/ui/product_description_page/basic_description_page.dart';
import 'package:liv_farm/ui/product_description_page/review_page.dart';
import 'package:liv_farm/ui/recommendation_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:liv_farm/viewmodel/review_page_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';

class ProductDescriptionPage extends StatefulWidget {
  @override
  _ProductDescriptionPageState createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage>
    with SingleTickerProviderStateMixin, Formatter {
  TabController _controller;
  ScrollController _scrollController;
  int selectedIndex = 0;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
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
          NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                BasicDescriptionPage(
                  product: product,
                ),
                SliverToBoxAdapter(
                  child: TabBar(
                      unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          letterSpacing: 1,
                          fontSize: 13),
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        letterSpacing: 1,
                      ),
                      indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 3.0, color: Color(kMainColor)),
                          insets: EdgeInsets.symmetric(horizontal: 30)),
                      controller: _controller,
                      tabs: [
                        Tab(
                          child: Text(
                            '상세정보',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Tab(
                          child: Text(
                            '리뷰',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ]),
                ),
              ];
            },
            controller: _scrollController,
            body: TabBarView(controller: _controller, children: [
              AdditionalInformationPage(
                product: product,
              ),
              ChangeNotifierProvider<ReviewPageViewModel>(
                  create: (context) => ReviewPageViewModel(product.id),
                  child: ReviewPage())
            ]),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: FlatButton(
                    disabledColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.zero,
                    color: Color(kSubColorRed),
                    child: Text(
                      '장바구니에 담기',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () async {
                      dynamic isAdded = await showBarModalBottomSheet(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.5),
                        shape: Border.all(width: 0.0),
                        expand: false,
                        builder: (context) => AddBottomSheet(
                          product: _model.product,
                        ),
                      );
                      if (isAdded == true) {
                        await _shoppingCartViewModel.addProduct(
                            _model.product,
                            Provider.of<LandingPageViewModel>(context,
                                    listen: false)
                                .user
                                .id);
                        Navigator.pop(context);
                      }
                      if (product.productCategory == 1)
                        await showBarModalBottomSheet(
                          expand: true,
                          context: context,
                          builder: (context) => RecommendationPage(
                            sideProductList:
                                Provider.of<OnlineShoppingViewmodel>(context,
                                        listen: false)
                                    .productList
                                    .where((element) =>
                                        element.productCategory == 4)
                                    .toList(),
                            dressingProductList:
                                Provider.of<OnlineShoppingViewmodel>(context,
                                        listen: false)
                                    .productList
                                    .where((element) =>
                                        element.productCategory == 5)
                                    .toList(),
                          ),
                        );
                    },
                  ),
                ),
              ),
            ),
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
