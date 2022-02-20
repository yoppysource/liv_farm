import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
  // final FirebaseAnalytics _analytics = FirebaseAnalytics();
  // FirebaseAnalyticsObserver getAnalyticsObserver() =>
  //     FirebaseAnalyticsObserver(analytics: _analytics);
  Future setUserProperties({required userEmail}) async {
    await _analytics.setUserId(id: userEmail);
  }

  Future logLogin(String loginMethod) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  Future logSignUp(String signUpMethod) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  Future logAddCart(
      {required String id,
      required String productName,
      required String productCategory,
      required int quantity}) async {
    await _analytics.logAddToCart(items: [
      AnalyticsEventItem(
          itemId: id,
          itemName: productName,
          itemCategory: productCategory,
          quantity: quantity)
    ]);
  }

  Future<void> logPurchase({
    required double purchaseAmount,
    required String couponDescription,
  }) async {
    await _analytics.logPurchase(
        value: purchaseAmount, coupon: couponDescription, currency: 'won');
  }

  Future logViewItem({
    required String itemId,
    required String itemName,
    required String itemCategory,
  }) async {
    await _analytics.logViewItem(
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
          itemCategory: itemCategory,
        )
      ],
    );
  }

  Future logSearch(String seachTerm) async {
    await _analytics.logSearch(searchTerm: seachTerm);
  }
}
