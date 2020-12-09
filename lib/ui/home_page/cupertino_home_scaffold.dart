import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home_page/home_page.dart';


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
          currentIndex: currentTab.index,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          items: [
            //TODO: stateless로 불러오기.
            _buildItem(TabItem.myFarm),
            _buildItem(TabItem.home),
            _buildItem(TabItem.shoppingCart),
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

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.black : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        color: color,
      ),
    );
  }
}
