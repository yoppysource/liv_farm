import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductGridView extends StatelessWidget with Formatter {
  final List<int> categoryList;
  final bool isOneItemForRow;

  const ProductGridView({Key key,@required this.categoryList, @required this.isOneItemForRow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildGridView(context, categoryList);
  }


  Widget buildGridView(
      BuildContext context, List<int> categoryList) {
    List<Product> _productList = [];
    OnlineShoppingViewmodel _model =
        Provider.of<OnlineShoppingViewmodel>(context, listen: false);
    for (int categoryNum in categoryList) {
      List<Product> _temp = _model.productList
          .where((element) => element.productCategory == categoryNum)
          .toList();
      _productList.addAll(_temp);
    }

    return GridView.builder(
      itemCount: _productList.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: isOneItemForRow ? 1 : 0.55, crossAxisCount:isOneItemForRow ? 1 : 2),
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
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                    child: CachedNetworkImage(
                      imageUrl: _productList[index].thumbnailPath,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fadeInDuration: Duration(milliseconds: 50),
                      fit: isOneItemForRow ? BoxFit.cover:BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${_productList[index].productName}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '${getPriceFromInt(_productList[index].productPrice)}',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.8), letterSpacing: 0.7),)
                          ],
                        ),
                      ),
                      Provider.of<LandingPageViewModel>(context,listen: false).user == null? Container() :
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
    );
  }
}
