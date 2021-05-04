// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:stacked/stacked.dart';

import '../model/product.dart';
import '../ui/auth/certification/certification_view.dart';
import '../ui/auth/login/login_view.dart';
import '../ui/auth/signup/signup_view.dart';
import '../ui/home/farm/product_detail/product_detail_view.dart';
import '../ui/home/home_view.dart';
import '../ui/home/shopping_cart/purchase/purchase_view.dart';
import '../ui/landing/landing_view.dart';
import '../ui/landing/video_view.dart';

class Routes {
  static const String landingView = '/';
  static const String loginView = '/login-view';
  static const String signupView = '/signup-view';
  static const String videoView = '/video-view';
  static const String certificationView = '/certification-view';
  static const String productDetailView = '/product-detail-view';
  static const String homeView = '/home-view';
  static const String purchaseView = '/purchase-view';
  static const all = <String>{
    landingView,
    loginView,
    signupView,
    videoView,
    certificationView,
    productDetailView,
    homeView,
    purchaseView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.landingView, page: LandingView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.signupView, page: SignupView),
    RouteDef(Routes.videoView, page: VideoView),
    RouteDef(Routes.certificationView, page: CertificationView),
    RouteDef(Routes.productDetailView, page: ProductDetailView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.purchaseView, page: PurchaseView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    LandingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LandingView(),
        settings: data,
      );
    },
    LoginView: (data) {
      var args = data.getArgs<LoginViewArguments>(
        orElse: () => LoginViewArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => LoginView(key: args.key),
        settings: data,
      );
    },
    SignupView: (data) {
      var args = data.getArgs<SignupViewArguments>(
        orElse: () => SignupViewArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => SignupView(key: args.key),
        settings: data,
      );
    },
    VideoView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => VideoView(),
        settings: data,
      );
    },
    CertificationView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const CertificationView(),
        settings: data,
      );
    },
    ProductDetailView: (data) {
      var args = data.getArgs<ProductDetailViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => ProductDetailView(
          key: args.key,
          product: args.product,
        ),
        settings: data,
      );
    },
    HomeView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    PurchaseView: (data) {
      var args = data.getArgs<PurchaseViewArguments>(
        orElse: () => PurchaseViewArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => PurchaseView(
          key: args.key,
          paymentData: args.paymentData,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// LoginView arguments holder class
class LoginViewArguments {
  final Key key;
  LoginViewArguments({this.key});
}

/// SignupView arguments holder class
class SignupViewArguments {
  final Key key;
  SignupViewArguments({this.key});
}

/// ProductDetailView arguments holder class
class ProductDetailViewArguments {
  final Key key;
  final Product product;
  ProductDetailViewArguments({this.key, @required this.product});
}

/// PurchaseView arguments holder class
class PurchaseViewArguments {
  final Key key;
  final PaymentData paymentData;
  PurchaseViewArguments({this.key, this.paymentData});
}
