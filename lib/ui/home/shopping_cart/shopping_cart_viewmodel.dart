import 'dart:async';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/item.dart';
import 'package:liv_farm/model/order.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/address_select/address_select_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/purchase/purchase_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ShoppingCartViewModel extends BaseViewModel {
  UserProviderService _userProviderService = locator<UserProviderService>();
  ServerService _serverService =
      ServerService(apiPath: APIPath(resource: Resource.carts));
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();
  Coupon selectedCoupon;
  DateTime selectedDateTime;
  //TODO:테스트 바꾸기
  Address get selectedAddress => _userProviderService.user.addresses.isNotEmpty
      ? _userProviderService.user.addresses[0]
      : null;

  //About Cart
  Cart get cart => _userProviderService.user?.cart ?? null;
  int get cartLength => cart?.items?.length ?? 0;
  String deliveryRequest = '';
  String deliveryReservationMessage = '';
  int get totalPrice {
    int price = 0;
    if (cart == null || cart.items.isEmpty) return 0;
    this
        .cart
        .items
        .forEach((item) => price += item.product.price * item.quantity);
    return price;
  }

  int get discountAmount {
    return totalPrice - finalPrice;
  }

  int get finalPrice {
    return _totalDiscountedPrice - _couponDiscountAmount;
  }

  int get _totalDiscountedPrice {
    int price = 0;
    if (cart == null || cart.items.isEmpty) return 0;
    this.cart.items.forEach(
        (item) => price += item.product.discountedPrice * item.quantity);
    return price;
  }

  int get _couponDiscountAmount {
    return 0;
  }

  Future<void> syncCart() async {
    Map<String, dynamic> cartJson =
        await _serverService.getData(path: '/myCart');
    print(cartJson);
    _userProviderService.user.cart = Cart.fromJson(cartJson['data']);
    notifyListeners();
  }

  Future<void> addToCart({String productId, int quantity}) async {
    try {
      await _serverService.postData(
          data: {'product': productId, 'quantity': quantity},
          path: '/myCart/items');
      await syncCart();
      notifyListeners();
      ToastMessageService.showToast(message: '장바구니에 담았습니다');
    } catch (e) {
      _dialogService.showDialog(
          title: '오류',
          description: e.message.toString(),
          barrierDismissible: true,
          buttonTitle: '확인');
    }
  }

  Future<void> removeFromCart(Item item) async {
    try {
      cart.items.remove(item);
      notifyListeners();
      await _serverService.deleteData(path: '/myCart/items/${item.id}');
      await syncCart();
      notifyListeners();
    } catch (e) {
      print(e);
      _dialogService.showDialog(
          title: '오류',
          description: e.message.toString(),
          barrierDismissible: true,
          buttonTitle: '확인');
    }
  }

  Future<void> increaseItemQuantity(Item item) async {
    try {
      item.quantity += 1;
      notifyListeners();
      await _serverService.patchData(
          path: '/myCart/items/${item.id}', data: {'quantity': item.quantity});
    } catch (e) {
      _dialogService.showDialog(
          title: '오류',
          description: e.message.toString(),
          barrierDismissible: true,
          buttonTitle: '확인');
    }
  }

  Future<void> decreaseItemQuantity(Item item) async {
    try {
      item.quantity -= 1;
      notifyListeners();
      await _serverService.patchData(
          path: '/myCart/items/${item.id}', data: {'quantity': item.quantity});
    } catch (e) {
      _dialogService.showDialog(
          title: '오류',
          description: e.message.toString(),
          barrierDismissible: true,
          buttonTitle: '확인');
    }
  }

  // Customer can select the time they want.

  //Get Delivery Request From Customer

  Future<void> callBottomSheetToGetInput() async {
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        customData: {'maxLength': 50, 'text': this.deliveryRequest},
        title: '요청사항');
    if (_sheetResponse.confirmed)
      this.deliveryRequest = _sheetResponse.responseData['input'];
    notifyListeners();
  }

  void onPressedAddress() {
    _navigationService.navigateToView(AddressSelectView());
  }

  bool get isPhoneNumberAndNameExisted =>
      (_userProviderService.user.name != null &&
          _userProviderService.user.phoneNumber != null &&
          _userProviderService.user.name != '' &&
          _userProviderService.user.phoneNumber != '');

  bool get isPossibleToPurchase =>
      (this.selectedAddress != null) && isPhoneNumberAndNameExisted;
  //Onpressed On order
  String get purchaseButtonMessage {
    if (this.selectedAddress == null) {
      return "상단에서 배송지를 입력해주세요";
    } else if (!isPhoneNumberAndNameExisted) {
      return "주문자 정보를 입력해주세요";
    } else if (this.finalPrice < 1000) {
      return "최소 금액은 1000원 이상입니다.";
    } else {
      return "결제하기";
    }
  }

  void rebuild() {
    notifyListeners();
  }

  void onPressedOnPayment() {
    String orderId = "${_userProviderService.user.id}_${DateTime.now()}";
    _navigationService.navigateWithTransition(
        PurchaseView(
            paymentData: PaymentData.fromJson({
              'pg': "html5_inicis",
              'payMethod': 'card',
              'name':
                  "${this.cart.items[0].product.name} 포함 ${this.cart.items.length}건에 대한 주문",
              'amount': 10,
              'customData': {
                "scheduledDate": selectedDateTime?.toIso8601String() ?? '',
                "deliveryRequest": this.deliveryRequest ?? '',
                "customerId": _userProviderService.user.id,
                "cartId": cart.id,
              },
              'merchantUid': "$orderId",
              'buyerName': "${_userProviderService.user.name}",
              'buyerTel': "${_userProviderService.user.phoneNumber}",
              'buyerEmail': "${_userProviderService.user.email}",
              'buyerAddr':
                  "${this.selectedAddress.address} ${this.selectedAddress?.addressDetail ?? ""}",
              'buyerPostcode': this.selectedAddress.postcode,
              'appScheme': "livFarm",
              'display': {
                'cardQuota': [2, 3] //결제창 UI 내 할부개월수 제한
              }
            }),
            order: Order(
                id: orderId,
                status: 0,
                deliveryReservationMessage: this.deliveryReservationMessage,
                address: this.selectedAddress,
                cart: this.cart,
                paidAmount: this.finalPrice,
                user: _userProviderService.user,
                payMethod: "card",
                scheduledDate: this.selectedDateTime,
                deliveryRequest: this.deliveryRequest,
                coupon: this.selectedCoupon)),
        transition: 'fade');
  }
}
