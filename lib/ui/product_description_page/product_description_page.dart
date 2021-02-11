import 'package:flutter/material.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/service/analytic_service.dart';
import 'package:liv_farm/ui/auth_page.dart';
import 'package:liv_farm/ui/product_description_page/add_bottom_sheet.dart';
import 'package:liv_farm/ui/product_description_page/basic_description_page.dart';
import 'package:liv_farm/ui/product_description_page/bottom_tab_bar.dart';
import 'package:liv_farm/ui/shared/buttons/bottom_float_buttom.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/login_suggestion_dialog.dart';
import 'package:liv_farm/utill/get_it.dart';
import 'package:liv_farm/viewmodel/add_bottom_sheet_view_model.dart';
import 'package:liv_farm/viewmodel/auth_page_view_model.dart';
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
  TabController controller;

  @override
  void initState() {
    if (mounted) {
      Provider.of<ProductDescriptionViewmodel>(context, listen: false)
          .lazyLoad();
    }
    //
    controller= TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LandingPageViewModel _landingPageViewModel =  Provider.of<LandingPageViewModel>(context, listen: false);
    ProductDescriptionViewmodel _model =
        Provider.of<ProductDescriptionViewmodel>(context, listen: true);
    Product product = _model.product;
    ShoppingCartViewmodel _shoppingCartViewModel = _landingPageViewModel.user != null? Provider.of<ShoppingCartViewmodel>(context, listen: false): null;


    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                BasicDescriptionPage(
                  product: product,
                  inventory:
                      _model.isLazyLoaded == false ? null : _model.inventory,
                ),
                // BottomBar(tabController: controller,),
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
                  product: product,
                ),
              ],
            ),
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
          if(_landingPageViewModel.user ==null) BottomFloatButton(
            text: '상품을 주문하시려면 로그인이 필요합니다',
            onPressed: () async {
              bool pressYes = await LoginSuggestionDialog().show(context);
              if(pressYes){
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => AuthPageViewmodel(_landingPageViewModel),
                      child: AuthPage(),
                    ),
                    fullscreenDialog: true,
                  ),
                );
              }
            },
          )
          else if (_model.isLazyLoaded == true && !(_model.product.productCategory ==9 || _model.product.productCategory ==10))
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
                        temp.forEach((product)async {

                          await _shoppingCartViewModel.addProduct(
                              product,
                              Provider.of<LandingPageViewModel>(context,
                                  listen: false)
                                  .user
                                  .id,
                              _model.inventory);
                        });
                        await locator<AnalyticsService>().logAddCart(id: product.id, productName: product.productName, productCategory: Product.categoryMap[product.productCategory], quantity:product.productQuantity);
                        Navigator.pop(context);
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
