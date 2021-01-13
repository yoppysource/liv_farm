import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/ui/landing_page.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  KakaoContext.clientId = kakaoClientId;
  runApp(ChangeNotifierProvider(
      create: (context) => LandingPageViewModel(), child: MyApp()));
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
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KO'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(kMainColor),
        fontFamily: 'Spoqa Han Sans',
      ),
      home: LandingPage(),
    );
  }
}
