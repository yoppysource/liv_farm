import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/ui/auth_page.dart';
import 'package:liv_farm/ui/home_page/home_page.dart';
import 'package:badges/badges.dart';
import 'package:liv_farm/ui/shared/buttons/bottom_float_buttom.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/login_suggestion_dialog.dart';
import 'package:liv_farm/viewmodel/auth_page_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';


class CupertinoHomeScaffold extends StatefulWidget {
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
  _CupertinoHomeScaffoldState createState() => _CupertinoHomeScaffoldState();
}

class _CupertinoHomeScaffoldState extends State<CupertinoHomeScaffold> {
  final CupertinoTabController _controller = CupertinoTabController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LandingPageViewModel _model = Provider.of<LandingPageViewModel>(context,listen: false);
    return CupertinoTabScaffold(
      controller: _controller,
        tabBar: CupertinoTabBar(
          activeColor: Color(kMainColor),
          iconSize: 26,
          currentIndex: widget.currentTab.index,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          items: [
            _buildItem(TabItem.home, context),
            _buildItem(TabItem.onlineShopping,context),
            _buildItem(TabItem.myFarm,context),
            _buildItem(TabItem.shoppingCart,context),
          ],
          onTap: (index) {
            if(_model.user == null && index > 1){
                  _controller.index = widget.currentTab.index;
            }
              return widget.onSelectTab(TabItem.values[index]);
            },
        ),
        tabBuilder: (context, index) {
            final item = TabItem.values[index];
            return CupertinoTabView(
              navigatorKey: widget.navigatorKeys[item],
              builder: (context) => widget.widgetBuilders[item](context),
            );
          // }
        },
      );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem,BuildContext context) {
    LandingPageViewModel _model = Provider.of<LandingPageViewModel>(context,listen: false);
    final itemData = TabItemData.allTabs[tabItem];
    final color = widget.currentTab == tabItem ? Color(kMainColor) : Colors.grey;
    if(tabItem == TabItem.shoppingCart){
      return BottomNavigationBarItem(
        label: itemData.title,
        icon: _model.user == null ?  Icon(
          itemData.icon,
          color: color,
        ) : Badge(
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
        size: tabItem == TabItem.onlineShopping ? 23: null,
      ),
    );
  }
}
