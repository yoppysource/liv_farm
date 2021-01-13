import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liv_farm/liv_farm_page/liv_farm_page.dart';
import 'package:liv_farm/search_page/search_page.dart';
import 'package:liv_farm/ui/home_page/cupertino_home_scaffold.dart';
import 'package:liv_farm/ui/icons.dart';
import 'package:liv_farm/ui/my_farm_page/my_farm_page.dart';
import 'package:liv_farm/ui/online_shopping_page/online_shopping_page.dart';
import 'package:liv_farm/ui/shared/custom_icon.dart';
import 'package:liv_farm/ui/shopping_cart_page/shopping_cart_page.dart';
import 'package:liv_farm/viewmodel/home_page_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/my_farm_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.home;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.onlineShopping : GlobalKey<NavigatorState>(),
    TabItem.myFarm: GlobalKey<NavigatorState>(),
    TabItem.shoppingCart: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.home: (context) => LivFarmPage(),
      TabItem.onlineShopping: (context) => OnlineShoppingPage(),
      TabItem.myFarm: (context) => MyFarmPage(),
      TabItem.shoppingCart: (context) => ShoppingCartPage(),

    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }
  @override
  void initState() {
    if (mounted)
    Provider.of<OnlineShoppingViewmodel>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}

enum TabItem { home,  onlineShopping, myFarm,shoppingCart }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(title: '홈', icon: CupertinoIcons.home),
    TabItem.onlineShopping: TabItemData(title: '카테고리', icon: CupertinoIcons.list_bullet),
    TabItem.myFarm: TabItemData(title: '마이 팜', icon: CupertinoIcons.person),
    TabItem.shoppingCart: TabItemData(title: '장바구니', icon: UiIcons.shoppingCart),
  };
}
