import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/ui/home_page/home_page.dart';
import 'package:badges/badges.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';


class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(

        tabBar: CupertinoTabBar(
          activeColor: Color(kMainColor),
          iconSize: 26,
          currentIndex: currentTab.index,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          items: [
            _buildItem(TabItem.home, context),
            _buildItem(TabItem.onlineShopping,context),
            _buildItem(TabItem.myFarm,context),
            _buildItem(TabItem.shoppingCart,context),
          ],
          onTap: (index) => onSelectTab(TabItem.values[index]),
        ),
        tabBuilder: (context, index) {
          final item = TabItem.values[index];
          return CupertinoTabView(
            //Key for align navigator
            navigatorKey: navigatorKeys[item],
            builder: (context) => widgetBuilders[item](context),
          );
        },
      );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem,BuildContext context) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Color(kMainColor) : Colors.grey;
    if(tabItem == TabItem.shoppingCart){
      return BottomNavigationBarItem(
        label: itemData.title,
        icon: Badge(
          animationType: BadgeAnimationType.fade,
          badgeColor:  Color(kMainColor),
          badgeContent: Text(
            Provider.of<ShoppingCartViewmodel>(context,listen: true).shoppingCart?.length.toString() ?? '0',
            style: TextStyle(color: Colors.white),
          ),
          child: Icon(
            itemData.icon,
            color: color,
          ),
        ),
      );
    }
    return BottomNavigationBarItem(
      label: itemData.title,
      icon: Icon(
        itemData.icon,
        color: color,
      ),
    );
  }
}
