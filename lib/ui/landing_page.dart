import 'package:flutter/material.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:liv_farm/ui/auth_page.dart';
import 'package:liv_farm/ui/home_page/home_page.dart';
import 'package:liv_farm/ui/my_farm_page/my_farm_page.dart';
import 'package:liv_farm/ui/splash_page.dart';
import 'package:liv_farm/viewmodel/auth_page_view_model.dart';
import 'package:liv_farm/viewmodel/home_page_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/my_farm_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: return 일 때는 rebuild를 해도 반영이 안된다. 왜??
    log.builderLog(className: 'LandingPage');
    LandingPageViewModel _model =
        Provider.of<LandingPageViewModel>(context, listen: true);
    if (_model?.isBusy == true) {
      return SplashPage();
    } else if (_model?.user == null) {
      return ChangeNotifierProvider<AuthPageViewmodel>(
        create: (context) => AuthPageViewmodel(_model),
        child: AuthPage(),
      );
    } else {
      return MultiProvider(
        providers: [
          // ChangeNotifierProvider(
          //   create: (_) => HomePageViewModel(
          //     user: _model.user,
          //   ),
          // ),
          ChangeNotifierProvider(
            create: (context) => OnlineShoppingViewmodel(),
          ),
          ChangeNotifierProvider(
            create: (context) => ShoppingCartViewmodel(),
          ),
          ChangeNotifierProvider<MyFarmPageViewModel>(
              create: (context) => MyFarmPageViewModel(_model.user)),
        ],
        child: HomePage(),
      );
    }
  }
}
