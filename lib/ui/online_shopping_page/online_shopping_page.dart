import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/main.dart';
import 'package:liv_farm/ui/farm_video_page.dart';
import 'package:liv_farm/ui/online_shopping_page/shopping_bar_view.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/in_app_button.dart';
import 'package:liv_farm/ui/shared/buttons/refresh_button.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/platform_exception_alert_dialog.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_drawer.dart';
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
    _tabController = TabController(length: 5, vsync: this, initialIndex: index);
    Provider.of<OnlineShoppingViewmodel>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    OnlineShoppingViewmodel _model =
        Provider.of<OnlineShoppingViewmodel>(context, listen: true);
    //List must be checked with isEmpty method.
    if (_model.productList == null) {
      return Scaffold(
        drawer: MyDrawer(),
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
        drawer: MyDrawer(),
        appBar: MyAppBar(),
        body: Center(
          child: RefreshButton(onPressed: () async => _model.init()),
        ),
      );
    } else {
      return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          actions: [IconButton(icon: Icon(CupertinoIcons.search), onPressed: (){})],
          title: SizedBox(
              height: 40,
              width: 80,
              child: Image.asset(kLogo,color: Color(kMainColor),)),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),),
        body: DefaultTabController(
          length: 5,
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

