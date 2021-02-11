import 'package:flutter/material.dart';
import 'package:liv_farm/ui/auth_page.dart';
import 'package:liv_farm/ui/home_page/home_page.dart';
import 'package:liv_farm/ui/splash_page.dart';
import 'package:liv_farm/viewmodel/auth_page_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/my_farm_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LandingPageViewModel _model =
        Provider.of<LandingPageViewModel>(context, listen: true);
    if (_model?.isBusy == true) {
      return SplashPage();
    } else if (_model?.user == null) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<OnlineShoppingViewmodel>(
            create: (context) => OnlineShoppingViewmodel(),
          ),
        ],
        child: HomePage(),
      );
      //   ChangeNotifierProvider<AuthPageViewmodel>(
      //   create: (context) => AuthPageViewmodel(_model),
      //   child: AuthPage(),
      // );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<OnlineShoppingViewmodel>(
            create: (context) => OnlineShoppingViewmodel(),
          ),
          ChangeNotifierProvider<ShoppingCartViewmodel>(
            create: (context) => ShoppingCartViewmodel(_model.user),
          ),
          ChangeNotifierProvider<MyFarmPageViewModel>(
              create: (context) => MyFarmPageViewModel(_model.user)),
        ],
        child: HomePage(),
      );
    }
  }
}
