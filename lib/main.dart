import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/ui/home/home_view.dart';
import 'package:liv_farm/ui/landing/landing_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:liv_farm/ui/shared/styles.dart';

import 'package:stacked_services/stacked_services.dart';

import 'app/app.router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  KakaoContext.clientId = kakaoClientId;
  setupLocator();
  setupBottomSheetUi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      supportedLocales: [
        const Locale('ko', 'KO'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'LivFarm',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: kMainIvory,
          iconTheme: IconThemeData(
            color: kMainPink,
          ),
          elevation: 0.0,
        ),
        dialogTheme: DialogTheme(
          titleTextStyle: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Spoqa Han Sans',
              color: Color(0xff333333)),
          contentTextStyle: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Spoqa Han Sans',
              color: Color(0xff333333)),
        ),
        scaffoldBackgroundColor: kMainIvory,
        accentColor: kMainPink,
        fontFamily: 'Spoqa Han Sans',
        textTheme: TextTheme(
          subtitle1: TextStyle(
              fontSize: 30.0,
              fontFamily: 'Spoqa Han Sans',
              color: Color(0xff333333)),
          subtitle2: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Spoqa Han Sans',
              color: Color(0xff333333)),
          bodyText1: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Spoqa Han Sans',
              color: Color(0xff333333)),
          bodyText2: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Spoqa Han Sans',
              color: Color(0xff828282)),
        ),
      ),
      home: LandingView(),
    );
  }
}
