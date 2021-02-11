import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liv_farm/ui/auth_page.dart';
import 'package:liv_farm/ui/home_page/cupertino_home_scaffold.dart';
import 'package:liv_farm/ui/icons.dart';
import 'package:liv_farm/ui/liv_farm_page/liv_farm_page.dart';
import 'package:liv_farm/ui/my_farm_page/my_farm_page.dart';
import 'package:liv_farm/ui/online_shopping_page/online_shopping_page.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/login_suggestion_dialog.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';
import 'package:liv_farm/ui/shopping_cart_page/shopping_cart_page.dart';
import 'package:liv_farm/utill/my_flutter_app_icons.dart';
import 'package:liv_farm/viewmodel/auth_page_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSystemButtonPressed = false;
  TabItem _currentTab;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.onlineShopping : GlobalKey<NavigatorState>(),
    TabItem.myFarm: GlobalKey<NavigatorState>(),
    TabItem.shoppingCart: GlobalKey<NavigatorState>(),
  };

  Future<bool> _systemBackButtonPressed() async {

    if (navigatorKeys[_currentTab].currentState.canPop())  {
      navigatorKeys[_currentTab]
          .currentState
          .pop(navigatorKeys[_currentTab].currentContext);
    } else {
      if (!isSystemButtonPressed){
        isSystemButtonPressed = true;
        ToastMessage().showSystemBackButtonPressed();
        await Future.delayed(Duration(seconds: 2), () {
          isSystemButtonPressed = false;
        });
      }
       else{
        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      }
    }
  }


  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.home: (context) => LivFarmPage(),
      TabItem.onlineShopping: (context) => OnlineShoppingPage(),
      TabItem.myFarm: (context) => MyFarmPage(),
      TabItem.shoppingCart: (context) => ShoppingCartPage(),
    };
  }

  Future<void> _select(TabItem tabItem)async {
    LandingPageViewModel _model = Provider.of<LandingPageViewModel>(context,listen: false);
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      if(_model.user == null && tabItem.index>1){
        bool pressYes = await LoginSuggestionDialog().show(context);
            if(pressYes){
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => AuthPageViewmodel(_model),
                    child: AuthPage(),
                  ),
                  fullscreenDialog: true,
                ),
              );
      }} else {
        setState(() => _currentTab = tabItem);
      }
      // if(_model.user == null && index > 1)
      //   {
      //     _controller.index = widget.currentTab.index;
      //     bool pressYes = await LoginSuggestionDialog().show(context);
      //     if(pressYes){
      //       Navigator.of(context, rootNavigator: true).push(
      //         MaterialPageRoute(
      //           builder: (context) => ChangeNotifierProvider(
      //             create: (context) => AuthPageViewmodel(_model),
      //             child: AuthPage(),
      //           ),
      //           fullscreenDialog: true,
      //         ),
      //       );
      //     }
      //   }


    }
  }
  @override
  void initState() {
    if (mounted)
      _currentTab = TabItem.home;
    Provider.of<OnlineShoppingViewmodel>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // if(_currentTab == TabItem.home){
    //   LivFarmPage.controller.play();
    // }
    return WillPopScope(
      onWillPop:  () async => await _systemBackButtonPressed(),
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
    TabItem.onlineShopping: TabItemData(title: '농장', icon:  MyFlutterApp.plant_1),
    TabItem.myFarm: TabItemData(title: '마이 팜', icon: CupertinoIcons.person),
    TabItem.shoppingCart: TabItemData(title: '장바구니', icon: UiIcons.shoppingCart),
  };
}
