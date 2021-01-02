import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/icons.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';
//TODO: homePage 제일 왼쪽에 두고, 가운데를 검색화면 마지막페이지, 장바구니 appBar에 위치.
class ShoppingBarView extends StatelessWidget with Formatter {
  const ShoppingBarView({
    Key key,
    @required TabController tabController,
    @required OnlineShoppingViewmodel model,
  })  : _tabController = tabController,
        _model = model,
        super(key: key);

  final TabController _tabController;
  final OnlineShoppingViewmodel _model;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: TabBarView(controller: _tabController, children: [
          buildGridView(context, 1),
          buildGridView(context, 2),
          buildGridView(context, 3),
          buildGridView(context, 4),
          buildGridView(context, 5),
        ]),
      ),
    );
  }

  GridView buildGridView(BuildContext context, int categoryNum) {
    List<Product> _productList = _model.productList
        .where((element) => element.productCategory == categoryNum)
        .toList();
    return GridView.builder(
      itemCount: _productList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.55, crossAxisCount: 2),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Product product =  _productList[index];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (context) => ProductDescriptionViewmodel(
                          product:product,

                      ),
                      child: ProductDescriptionPage())));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Hero(
                    tag: '${_productList[index].id}',
                    child: Image.network(
                      '${_productList[index].imagePath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${_productList[index].productName}', style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(height: 3,),
                            Text(
                              '${getPriceFromInt(_productList[index].productPrice)}',
                              style: TextStyle(
                                letterSpacing: 0.3,
                                 fontSize: 17,
                                  color: Colors.black.withOpacity(0.8)),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                icon: Icon(UiIcons.shoppingCart,
                                    size: 25,
                                    color: Color(0xffC5299B)),
                                onPressed: () {
                                  Provider.of<ShoppingCartViewmodel>(context,listen: false).addProduct(Product.copy(_productList[index]), Provider.of<LandingPageViewModel>(context,listen: false).user.id);
                                })),
                      )
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
