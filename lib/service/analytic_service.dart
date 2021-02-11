import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:liv_farm/model/product.dart';

class AnalyticsService {
  final _analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver getAnalyticsObserver() => FirebaseAnalyticsObserver(analytics: _analytics);

  Future setUserProperties({@required String userId}) async {
    await _analytics.setUserId(userId);
  }

  Future logViewItem({@required id, @required productName, @required productCategory}) async {
    await _analytics.logViewItem(itemId: id.toString(), itemName: productName, itemCategory: Product.categoryMap[productCategory]);
  }

  Future logAppOpen() async {
 await _analytics.logAppOpen();
  }

  Future logAddCart({@required id, @required productName, @required productCategory , @required quantity}) async {
    await _analytics.logAddToCart(itemId: id.toString(), itemName: productName, itemCategory: Product.categoryMap[productCategory], quantity: quantity);
  }

  Future logPurchase({@required totalValue, @required couponId, @required address}) async {
    await  _analytics.logEcommercePurchase(value: totalValue, coupon: couponId.toString(), location: address,currency: 'won');
}
}