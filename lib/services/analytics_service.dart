import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);
  Future setUserProperties({@required userEmail}) async {
    await _analytics.setUserId(userEmail);
  }

  Future logLogin(String loginMethod) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  Future logSignUp(String signUpMethod) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  Future logAddCart(
      {@required String id,
      @required String productName,
      @required String productCategory,
      @required int quantity}) async {
    await _analytics.logAddToCart(
        itemId: id.toString(),
        itemName: productName,
        itemCategory: productCategory,
        quantity: quantity);
  }

  Future logPurchase(
      {@required double purchaseAmount,
      @required couponDescription,
      @required address}) async {
    await _analytics.logEcommercePurchase(
        value: purchaseAmount,
        coupon: couponDescription,
        location: address,
        currency: 'won');
  }

  Future logViewItem({
    @required String itemId,
    @required String itemName,
    @required String itemCategory,
    double price,
    String currency,
    double value,
  }) async {
    await _analytics.logViewItem(
        itemId: itemId,
        itemName: itemName,
        itemCategory: itemCategory,
        price: price,
        currency: currency);
  }

  Future logSearch(String seachTerm) async {
    await _analytics.logSearch(searchTerm: seachTerm);
  }
}
