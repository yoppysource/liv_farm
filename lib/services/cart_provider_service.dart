import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/services/server_service/api_exception.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/toast_service.dart';

import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CartProviderService extends BaseViewModel with ReactiveServiceMixin {
  CartProviderService() {
    listenToReactiveValues([_cart]);
  }
  final RxValue<Cart?> _cart = RxValue<Cart?>(null);
  Cart? get cart => _cart.value;
  String get bottomNavigationBarItemText =>
      _cart.value == null ? '0' : _cart.value!.items.length.toString();

  Coupon? selectedCoupon;
  DateTime? bookingOrderDateTime;
  bool takeout = false;
  String orderRequestMessage = '';
  // String deliveryReservationMessage = '';
  final ClientService _clientService = locator<ClientService>();
  final DialogService _dialogService = locator<DialogService>();

  void syncCartFromInstance(Cart cart) {
    _cart.value = cart;
    notifyListeners();
  }

  void syncCartFromJson(Map<String, dynamic> data) {
    _cart.value = Cart.fromJson(data);
    notifyListeners();
  }

  Future<void> syncCartFromServer() async {
    Map<String, dynamic> cart = await _clientService.sendRequest(
        method: HttpMethod.get, resource: Resource.carts, endPath: '/my');
    syncCartFromJson(cart);
  }

  Future<void> updateCartWhenStoreSet(String storeId) async {
    if (cart != null && (cart!.storeId == null || cart!.storeId != storeId)) {
      Map<String, dynamic> cart = await _clientService.sendRequest(
          method: HttpMethod.patch,
          resource: Resource.carts,
          endPath: '/my',
          data: {'store': storeId});
      syncCartFromJson(cart);
    }
  }

  Future<void> addToCart(Item item) async {
    try {
      Map<String, dynamic> data = await _clientService.sendRequest(
          method: HttpMethod.post,
          resource: Resource.carts,
          data: item.toJson(),
          endPath: '/my/item');
      syncCartFromJson(data);

      ToastMessageService.showToast(message: '장바구니에 담았습니다');
    } on APIException catch (e) {
      await _dialogService.showDialog(
          title: '오류',
          description: e.message,
          barrierDismissible: true,
          buttonTitle: '확인');
    } catch (e) {
      await _dialogService.showDialog(
          title: '오류',
          description: "오류가 발생했습니다",
          barrierDismissible: true,
          buttonTitle: '확인');
    }
    notifyListeners();
  }

  void resetCart() {
    bookingOrderDateTime = null;
    orderRequestMessage = '';
    // deliveryReservationMessage = '';
    selectedCoupon = null;
    _cart.value!.items.clear();
    notifyListeners();
  }
}
