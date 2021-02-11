import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/online_shopping_page/product_search_delegate.dart';
import 'package:liv_farm/ui/online_shopping_page/shopping_bar_view.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/refresh_button.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/platform_exception_alert_dialog.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:provider/provider.dart';

import 'my_tab_bar.dart';

class OnlineShoppingPage extends StatefulWidget {
  @override
  _OnlineShoppingPageState createState() => _OnlineShoppingPageState();
}

class _OnlineShoppingPageState extends State<OnlineShoppingPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: index);
  }

  @override
  Widget build(BuildContext context) {
    OnlineShoppingViewmodel _model =
        Provider.of<OnlineShoppingViewmodel>(context, listen: true);


    if (_model.productList == null) {
      return Scaffold(
        appBar: MyAppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_model.productList.isEmpty) {
      PlatformExceptionAlertDialog(
              title: '서버 오류', content: '데이터 정보를 가져오는데 실패했습니다.')
          .show(context);
      return Scaffold(
        appBar: MyAppBar(),
        body: Center(
          child: RefreshButton(onPressed: () async => _model.init()),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: Icon(CupertinoIcons.search),
                  onPressed: () async {
                    String productName = await showSearch(
                        context: context,
                        delegate: ProductSearch(_model.productList));
                    if (productName != null) {
                      Product searchedProduct = _model.productList.firstWhere(
                          (element) => element.productName == productName);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: 'ProductDescriptionPage'),
                          builder: (context) =>
                              ChangeNotifierProvider(
                                create: (context) =>
                                    ProductDescriptionViewmodel(
                                      product: searchedProduct,
                                    ),
                                child:  ProductDescriptionPage(),
                              ),
                             ),
                      );
                    }
                  }),
            )
          ],
          title: SizedBox(
              height: 40,
              width: 80,
              child: Image.asset(
                kLogo,
                color: Color(kMainColor),
              )),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 6,
              ),
              MyTabBar(tabController: _tabController),
              Expanded(
                child: ShoppingBarView(
                    tabController: _tabController, model: _model),
              ),
            ],
          ),
        ),
      );
    }
  }
}
