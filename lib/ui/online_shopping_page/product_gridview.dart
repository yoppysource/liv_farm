import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/repository/inventory_repository.dart';
import 'package:liv_farm/ui/icons.dart';
import 'package:liv_farm/ui/product_description_page/add_bottom_sheet.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';
import 'package:liv_farm/viewmodel/add_bottom_sheet_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:liv_farm/viewmodel/review_page_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductGridView extends StatefulWidget {
  final List<int> categoryList;

  const ProductGridView({Key key, this.categoryList}) : super(key: key);

  @override
  _ProductGridViewState createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> with Formatter {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            children: _buildTextBar(widget.categoryList),
          ),
        ),
        buildGridView(context, widget.categoryList, _selectedCategory)
      ],
    );
  }

  List<Widget> _buildTextBar(List<int> categoryIndex) {
    List<Widget> textList = [
      Padding(
        padding: const EdgeInsets.only(right: 28),
        child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = 0;
              });
            },
            child: Text(
              '모아보기',
              style: TextStyle(
                  color: _selectedCategory == 0
                      ? Color(kSubColorRed)
                      : Colors.black54),
            )),
      )
    ];
    textList.addAll(categoryIndex
        .map((e) => Padding(
              padding: const EdgeInsets.only(right: 35),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = e;
                    });
                  },
                  child: Text(
                    '${Product.categoryMap[e]}',
                    style: TextStyle(
                        color: _selectedCategory == e
                            ? Color(kSubColorRed)
                            : Colors.black54),
                  )),
            ))
        .toList());
    return textList;
  }

  Widget buildGridView(
      BuildContext context, List<int> categoryList, int selectedCategory) {
    List<Product> _productList = [];
    OnlineShoppingViewmodel _model =
        Provider.of<OnlineShoppingViewmodel>(context, listen: false);
    for (int categoryNum in categoryList) {
      List<Product> _temp = _model.productList
          .where((element) => element.productCategory == categoryNum)
          .toList();
      _productList.addAll(_temp);
    }

    if (selectedCategory != 0) {
      _productList = _productList
          .where((element) => element.productCategory == selectedCategory)
          .toList();
    }

    return Expanded(
      child: GridView.builder(
        itemCount: _productList.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.55, crossAxisCount: 2),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Product product = _productList[index];
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => ProductDescriptionViewmodel(
                      product: product,
                    ),
                    child: ProductDescriptionPage(),
                  ),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
                          padding:
                              const EdgeInsets.only(top: 10, left: 5, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${_productList[index].productName}',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
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
                                      size: 25, color: Color(0xffC5299B)),
                                  onPressed:() async {
                                      int inventory = await InventoryRepository().getInventoryNum(_productList[index].id);
                                      if(inventory == 0){
                                        ToastMessage().msg('재고가 부족합니다');
                                        return;
                                      }
                                    List<Product> temp = await showBarModalBottomSheet(
                                      context: context,
                                      barrierColor: Colors.black.withOpacity(0.5),
                                      shape: Border.all(width: 0.0),
                                      expand: false,
                                      builder: (context) => ChangeNotifierProvider<AddBottomSheetViewModel>(
                                        create: (context) => AddBottomSheetViewModel(
                                          productList: Provider.of<OnlineShoppingViewmodel>(context,listen: false).productList,
                                          selectedProduct: Product.copy(_productList[index]),
                                        ),
                                        child: AddBottomSheet(),
                                      ),);
                                    if (temp != null) {
                                      temp.forEach((element) async  {
                                        await Provider.of<ShoppingCartViewmodel>(context,
                                            listen: false)
                                            .addProduct(
                                            element,
                                            Provider.of<LandingPageViewModel>(
                                                context,
                                                listen: false)
                                                .user
                                                .id,inventory);
                                      });
                                    }
                                  },
                                  ),),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
