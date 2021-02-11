import 'package:flutter/material.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/ui/online_shopping_page/product_gridview.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';

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
          ProductGridView(categoryList: [4,8, 6,7], isOneItemForRow: false,),
          ProductGridView(categoryList: [1], isOneItemForRow:true),
          ProductGridView(categoryList: [2], isOneItemForRow:true),
        ]),
      ),
    );
  }
}