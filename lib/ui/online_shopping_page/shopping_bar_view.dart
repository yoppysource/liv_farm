import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/ui/online_shopping_page/product_gridview.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:liv_farm/viewmodel/review_page_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';

//TODO: homePage 제일 왼쪽에 두고, 가운데를 검색화면 마지막페이지, 장바구니 appBar에 위치.
class ShoppingBarView extends StatelessWidget with Formatter {
  const ShoppingBarView({
    Key key,
    @required TabController tabController,
    @required OnlineShoppingViewmodel model,
  })
      : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: TabBarView(controller: _tabController, children: [
          ProductGridView(categoryList: [1, 2]),
          // ProductGridView(categoryList: [9, 10]),
          ProductGridView(categoryList: [4]),
          ProductGridView(categoryList: [6, 7]),
          ProductGridView(categoryList: [8]),
        ]),
      ),
    );
  }
}