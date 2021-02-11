import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/service/root_navigation_service.dart';
import 'package:liv_farm/ui/auth_page.dart';
import 'package:liv_farm/ui/landing_page.dart';
import 'package:liv_farm/utill/get_it.dart';
import 'package:liv_farm/viewmodel/auth_page_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/payment_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  KakaoContext.clientId = kakaoClientId;
  setupLocator();
  runApp(ChangeNotifierProvider(
      create: (_) => LandingPageViewModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      navigatorKey: navigatorKey,
      supportedLocales: [
        const Locale('ko', 'KO'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'LivFarm',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
        ),
        primaryColor: Color(kMainColor),
        fontFamily: 'Spoqa Han Sans',
        textTheme: TextTheme(
          subtitle1: TextStyle(fontSize: 20.0, fontFamily: 'Spoqa Han Sans', color: Colors.black),
          bodyText1: TextStyle(fontSize: 16.0, fontFamily: 'Spoqa Han Sans', color: Colors.black.withOpacity(0.8)),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Spoqa Han Sans', color: Colors.black.withOpacity(0.7)),
        ),
      ),
      home: LandingPage(),
    );
  }
}
