import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/ui/home/farm/offline_farm/offline_farm_view.dart';
import 'package:liv_farm/ui/home/farm/online_farm/online_farm_view.dart';
import 'package:liv_farm/ui/home/home_viewmodel.dart';
import 'package:liv_farm/ui/home/my_farm/my_farm_view.dart';
import 'package:liv_farm/ui/home/order_history/order_history_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_view.dart';
import 'package:liv_farm/ui/home/video/video_view.dart';
import 'package:liv_farm/ui/shared/my_icons_icons.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSystemButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async => await _systemBackButtonPressed(),
        child: Scaffold(
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 500),
            reverse: model.reverse,
            child: _getViewForIndex(model.currentIndex, model),
            transitionBuilder: (Widget child, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                SharedAxisTransition(
              fillColor: kMainIvory,
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 28.0,
            selectedItemColor: kMainDarkGreen,
            unselectedItemColor: Colors.black54,
            selectedFontSize: 12.0,
            showUnselectedLabels: false,
            backgroundColor: kMainIvory,
            currentIndex: model.currentIndex,
            onTap: model.setIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.home,
                  ),
                  label: '홈'),
              BottomNavigationBarItem(
                  icon: Icon(
                    MyIcons.plant,
                  ),
                  label: '농장'),
              BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.square_favorites_alt,
                  ),
                  label: '주문내역'),
              BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.person,
                  ),
                  label: '마이팜'),
              BottomNavigationBarItem(
                  icon: ViewModelBuilder<CartProviderService>.reactive(
                    disposeViewModel: false,
                    initialiseSpecialViewModelsOnce: true,
                    viewModelBuilder: () => locator<CartProviderService>(),
                    builder: (context, model, child) => Badge(
                        position: BadgePosition.topEnd(top: -15, end: -10),
                        animationDuration: Duration(milliseconds: 500),
                        animationType: BadgeAnimationType.fade,
                        badgeColor: kMainGreen,
                        badgeContent: Text(
                          model.cart == null
                              ? '0'
                              : model.cart.items?.length.toString() ?? '0',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Icon(MyIcons.shopping_cart)),
                  ),
                  label: '장바구니')
            ],
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  Future<bool> _systemBackButtonPressed() async {
    if (!isSystemButtonPressed) {
      isSystemButtonPressed = true;
      ToastMessageService.showToast(message: '앱을 종료하실려면 한번 더 눌러주세요.');
      await Future.delayed(Duration(seconds: 2), () {
        isSystemButtonPressed = false;
      });
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
  }

  Widget _getViewForIndex(int index, HomeViewModel model) {
    switch (index) {
      case 0:
        return VideoView();
      case 1:
        return model.isOffineMode ? OfflineFarmView():  OnlineFarmView();
      case 2:
        return OrderHistoryView();
      case 3:
        return MyFarmView();
      case 4:
        return ShoppingCartView();
      default:
        return model.isOffineMode ? OfflineFarmView():  OnlineFarmView();
    }
  }
}
