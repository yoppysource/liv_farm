import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home_page/cupertino_home_scaffold.dart';
import 'package:liv_farm/ui/my_farm_page/my_farm_page.dart';
import 'package:liv_farm/ui/online_shopping_page/online_shopping_page.dart';
import 'package:liv_farm/ui/shopping_cart_page.dart';
import 'package:liv_farm/viewmodel/home_page_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/my_farm_page_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.home;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.myFarm: GlobalKey<NavigatorState>(),
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.shoppingCart: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      //In order to state management with provider, context should be input.
      TabItem.myFarm: (context) => MyFarmPage(),
      TabItem.home: (context) => OnlineShoppingPage(),
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

enum TabItem { myFarm, home, shoppingCart }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.myFarm: TabItemData(title: '', icon: Icons.account_circle_rounded),
    TabItem.home: TabItemData(title: '', icon: Icons.home),
    TabItem.shoppingCart: TabItemData(title: '', icon: Icons.shopping_cart),
  };
}
