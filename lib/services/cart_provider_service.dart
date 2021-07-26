import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/services/server_service/server_service.dart';

import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class CartProviderService extends BaseViewModel with ReactiveServiceMixin {
  CartProviderService() {
    listenToReactiveValues([_cart]);
  }
  RxValue<Cart> _cart = RxValue<Cart>();
  Cart get cart => _cart.value;
  Coupon selectedCoupon;
  DateTime bookingOrderDateTime;
  bool takeout = false;
  String orderRequestMessage = '';
  // String deliveryReservationMessage = '';
  ServerService _serverService = locator<ServerService>();

  void syncCartFromInstance(Cart cart) {
    this._cart.value = cart;
    notifyListeners();
  }

  void syncCartFromJson(Map<String, dynamic> data) {
    this._cart.value = Cart.fromJson(data);
    notifyListeners();
  }

  Future<void> syncCartFromServer() async {
    Map<String, dynamic> cart =
        await _serverService.getData(resource: Resource.carts, path: '/my');
    syncCartFromJson(cart);
  }

  void resetCart() {
    bookingOrderDateTime = null;
    orderRequestMessage = '';
    // deliveryReservationMessage = '';
    selectedCoupon = null;
    _cart.value.items = [];
    notifyListeners();
  }
}
