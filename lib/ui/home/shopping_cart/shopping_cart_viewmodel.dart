import 'dart:async';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/order.dart';
import 'package:liv_farm/model/store.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/in_offine_store_service.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/store_provider_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/address_select/address_select_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/purchase/purchase_option_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/purchase/purchase_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/pick_date_time_bottom_sheet/pick_date_time_bottom_sheet_viewmodel.dart';
import 'package:liv_farm/util/delivery_reservation_caluator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ShoppingCartViewModel extends ReactiveViewModel {
  UserProviderService _userProviderService = locator<UserProviderService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();
  CartProviderService _cartProviderService = locator<CartProviderService>();
  ServerService _serverService = locator<ServerService>();
  StoreProviderService _storeProviderService = locator<StoreProviderService>();
  final InOffineStoreService _inOffineStoreService =
      locator<InOffineStoreService>();
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_cartProviderService];
  final DateTime _now = DateTime.now();

  DeliveryReservationCaluator _caluator;

  Store get store => _storeProviderService.store;
  bool get takeOut => store.takeOut && _cartProviderService.takeout;
  bool get showBannerText => _userProviderService.user.addresses.isNotEmpty;
  int get availablePoint => _userProviderService.user.point;
  bool get isOffineMode => _inOffineStoreService.isOffineMode;
  int pointInput = 0;
  String get bannerText {
    if (impossibleToBuyBasedOnLocation && isOffineMode != true) {
      return "배송이 불가능한 지역입니다";
    } else {
      return "${_storeProviderService.store.name}에서 수확합니다";
    }
  }

  bool get impossibleToBuyBasedOnLocation =>
      _storeProviderService.isPossibleToBuy == false &&
      _userProviderService.user.addresses.isNotEmpty;

  Address get selectedAddress => _userProviderService.user.addresses.isNotEmpty
      ? _userProviderService.user.addresses[0]
      : null;
  //About Cart
  Cart get cart => _cartProviderService?.cart ?? null;
  int get cartLength => cart?.items?.length ?? 0;
  String get deliveryRequestMessage => _cartProviderService.orderRequestMessage;
  Coupon get selectedCoupon => _cartProviderService.selectedCoupon;

  String get bookingOrderMessage {
    String message = '';
    if (_cartProviderService.bookingOrderDateTime == null) {
      if (_caluator.isPossibleToBuyNow(this._now)) {
        message = "주문 후 바로 수확하여 30분 내로 받기";
      } else if (_caluator.dateTimePairedWithTimeOfDayList.keys.first.day ==
          this._now.day) {
        message = "오늘 ${_caluator.openHourOnApp}시에 받기";
      } else {
        message =
            "${_caluator.dateTimePairedWithTimeOfDayList.keys.first.day}일 (${_caluator.getWeekDaysName(_caluator.dateTimePairedWithTimeOfDayList.keys.first)}) ${_caluator.openHourOnApp}시에 받기";
      }
    } else {
      message =
          "${_cartProviderService.bookingOrderDateTime.day}일(${_caluator.getWeekDaysName(_cartProviderService.bookingOrderDateTime)}) ${_cartProviderService.bookingOrderDateTime.hour}시${_cartProviderService.bookingOrderDateTime.minute == 0 ? '' : " " + _cartProviderService.bookingOrderDateTime.minute.toString() + '분'}에 받기";
    }
    return message;
  }

  ShoppingCartViewModel() {
    _caluator = DeliveryReservationCaluator(
      _now,
      store.isOpenSaturday,
      store.isOpenSunday,
      store.isOpenToday,
      store.openHourStr,
      store.closeHourStr,
    );
  }

  int get totalPrice {
    int price = 0;
    if (cart == null || cart.items.isEmpty) return 0;
    this.cart.items.forEach(
        (item) => price += item.inventory.product.price * item.quantity);
    return price;
  }

  int get discountAmount {
    return totalPrice - finalPrice;
  }

  int get finalPrice {
    return _totalDiscountedPriceIncludePoint - _couponDiscountAmount;
  }

  int get _totalDiscountedPrice {
    int price = 0;
    if (cart == null || cart.items.isEmpty) return 0;
    this.cart.items.forEach((item) =>
        price += item.inventory.product.discountedPrice * item.quantity);
    return price;
  }

  int get _totalDiscountedPriceIncludePoint {
    if (_totalDiscountedPrice < this.pointInput) return _totalDiscountedPrice;
    return _totalDiscountedPrice - this.pointInput;
  }

  int get _couponDiscountAmount {
    if (_cartProviderService.selectedCoupon != null &&
        _cartProviderService.selectedCoupon.amount <
            this._totalDiscountedPriceIncludePoint) {
      return _cartProviderService.selectedCoupon.amount;
    } else {
      return 0;
    }
  }

  bool get isCouponAmountExceedDiscountedPrice =>
      (_cartProviderService.selectedCoupon != null &&
          _cartProviderService.selectedCoupon.amount >
              _totalDiscountedPriceIncludePoint);

  bool get isInputPointAmountExceedDiscountedPrice =>
      (this.pointInput != 0 && this.pointInput >= _totalDiscountedPrice);
  void onPressedDeliveryOption(bool takeout) {
    if (_cartProviderService.takeout != takeout) {
      _cartProviderService.takeout = takeout;
      notifyListeners();
    }
  }

  Future<void> increaseItemQuantity(Item item) async {
    try {
      if (item.inventory.inventory > item.quantity) {
        item.quantity += 1;
        notifyListeners();
        Map<String, dynamic> data =
            await _serverService.patchData<Map<String, dynamic>>(
                resource: Resource.carts,
                path: '/my/item',
                data: item.toJson());
        _cartProviderService.syncCartFromJson(data);
        notifyListeners();
      } else {
        ToastMessageService.showToast(message: "재고가 부족합니다");
      }
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
      Map<String, dynamic> data =
          await _serverService.patchData<Map<String, dynamic>>(
              resource: Resource.carts, path: '/my/item', data: item.toJson());
      _cartProviderService.syncCartFromJson(data);
      notifyListeners();
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
      Map<String, dynamic> data =
          await _serverService.postData<Map<String, dynamic>>(
              resource: Resource.carts,
              path: '/my/item/delete',
              data: item.toJson());
      _cartProviderService.syncCartFromJson(data);
      notifyListeners();
    } catch (e) {
      print(e);
      _dialogService.showDialog(
          title: '오류',
          description: e.message.toString(),
          barrierDismissible: true,
          buttonTitle: '확인');
    }
    notifyListeners();
  }

  Future<void> onPressPointInput() async {
    // if (this.availablePoint <= 1000) {
    //   return _dialogService.showDialog(
    //       title: '오류',
    //       description: "포인트는 1000점 이상부터 사용 가능합니다.",
    //       buttonTitle: '확인');
    // }
    this.pointInput = 0;
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.PointInput,
        customData: {"availablePoint": this.availablePoint},
        title: '사용가능 포인트: ${this.availablePoint}점');
    if (_sheetResponse.confirmed)
      this.pointInput = _sheetResponse.responseData['pointInput'];
    notifyListeners();
  }

  Future<void> callBottomSheetToGetInput() async {
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        customData: {
          'maxLength': 50,
          'text': _cartProviderService.orderRequestMessage,
        },
        title: '요청사항');
    if (_sheetResponse.confirmed)
      _cartProviderService.orderRequestMessage =
          _sheetResponse.responseData['input'];
    notifyListeners();
  }

  Future callBottomSheetToGetDateTime() async {
    if (this.isBusy == true) return;
    _cartProviderService.bookingOrderDateTime = null;
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.GetDateTime,
        title: this.bookingOrderMessage,
        customData: _caluator.dateTimePairedWithTimeOfDayList);
    if (_sheetResponse.confirmed) {
      print(_sheetResponse.responseData.toString());
      _cartProviderService.bookingOrderDateTime = _sheetResponse
          .responseData[PickDateTimeBottomSheetViewModel.KEY_selectedDate];
      notifyListeners();
    }
  }

  Future<void> onPressedCouponSelect() async {
    await _navigationService.navigateTo(Routes.couponView);
    notifyListeners();
  }

  Future<void> onPressedAddress() async {
    _inOffineStoreService.isOffineMode
        ? _dialogService.showDialog(
            title: '배송지',
            description: "매장 내 스캔을 하실 때는 사용할 수 없는 기능입니다.",
            buttonTitle: '확인',
            barrierDismissible: false,
          )
        : _navigationService.navigateToView(AddressSelectView());
    notifyListeners();
  }

  bool get isPhoneNumberAndNameExisted =>
      (_userProviderService.user.name != null &&
          _userProviderService.user.phoneNumber != null &&
          _userProviderService.user.name != '' &&
          _userProviderService.user.phoneNumber != '');

  bool get isPossibleToPurchase {
    if (this.isOffineMode == true && this.finalPrice >= 1000) return true;
    return (this.selectedAddress != null) &&
        isPhoneNumberAndNameExisted &&
        !impossibleToBuyBasedOnLocation &&
        this.finalPrice >= 1000;
  }

  //Onpressed On order
  String get purchaseButtonMessage {
    if (this.isOffineMode == true) {
    if (this.finalPrice < 1000) {
      return "최소 금액은 1000원 이상입니다";
    } else {
      return "결제하기";
    }
    }
    if (this.selectedAddress == null) {
      return "상단에서 배송지를 입력해주세요";
    } else if (impossibleToBuyBasedOnLocation) {
      return "배송이 불가능한 지역입니다";
    } else if (!isPhoneNumberAndNameExisted) {
      return "주문자 정보를 입력해주세요";
    } else if (this.finalPrice < 1000) {
      return "최소 금액은 1000원 이상입니다";
    } else {
      return "결제하기";
    }
  }

  Future<void> onPressedOnPayment() async {
    List<String> runOutItemNamesList = [];
    cart.items.forEach((Item item) {
      if (item.quantity > item.inventory.inventory) {
        runOutItemNamesList.add(item.inventory.product.name);
      }
    });
    if (runOutItemNamesList.isNotEmpty) {
      print(runOutItemNamesList.toString());
      String nameList = runOutItemNamesList.toString();
      _dialogService.showDialog(
          title: '재고 부족',
          description:
              '${nameList.substring(1, nameList.length - 1)} 재고가 부족합니다',
          buttonTitle: '확인');
      return;
    }

    String result = await _navigationService.navigateWithTransition(
        PurchaseOptionView(
          orderName:
              "${this.cart.items[0].inventory.product.name} 포함 ${this.cart.items.length}건에 대한 주문",
          amount: finalPrice,
          address: this.selectedAddress,
          orderRequestMessage: _cartProviderService.orderRequestMessage,
          bookingOrderMessage: this.bookingOrderMessage,
          option: this.isOffineMode ? "inStore" : this.takeOut ? 'takeOut' : 'delivery',
        ),
        transition: 'fade');
    if (result == null) {
      _dialogService.showCustomDialog(
          title: '취소', description: '결제를 취소하셨습니다', mainButtonTitle: '확인');
      return;
    }

    String orderId =
        "${_userProviderService.user.id}_${DateTime.now().millisecondsSinceEpoch}";
    await _navigationService.navigateWithTransition(
        PurchaseView(
            paymentData: PaymentData.fromJson({
              'pg': result,
              'payMethod': result == 'kakaopay' ? 'kakaopay' : 'card',
              'name':
                  "${this.cart.items[0].inventory.product.name} 포함 ${this.cart.items.length}건에 대한 주문",
              'amount': finalPrice,
              // 'amount': 10,
              'customData': {
                "option": this.isOffineMode ? "inStore" : this.takeOut ? "takeOut" : "delivery",
                "storeAddress": _storeProviderService.store?.address ?? '',
                "bookingOrderMessage": bookingOrderMessage ?? '',
                "orderRequestMessage":
                    _cartProviderService?.orderRequestMessage ?? '',
                "customerId": _userProviderService.user.id,
                "cartId": cart.id,
                "items": describeItems(),
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
                orderTitle:
                    "${this.cart.items[0].inventory.product.name} 포함 ${this.cart.items.length}건에 대한 주문",
                status: 0,
                option: this.isOffineMode ? "inStore" : this.takeOut ? "takeOut" : "delivery",
                bookingOrderMessage: this.bookingOrderMessage,
                address: this.selectedAddress,
                createdAt: DateTime.now(),
                cart: this.cart,
                storeId: this.cart.storeId,
                paidAmount: this.finalPrice,
                user: _userProviderService.user,
                payMethod: "card",
                usedPoint: (this.pointInput == 0 ||
                        isInputPointAmountExceedDiscountedPrice)
                    ? 0
                    : this.pointInput,
                scheduledDate: _cartProviderService.bookingOrderDateTime,
                orderRequestMessage: _cartProviderService.orderRequestMessage,
                coupon: (selectedCoupon == null ||
                        isCouponAmountExceedDiscountedPrice)
                    ? null
                    : selectedCoupon)),
        transition: 'fade');
    notifyListeners();
  }
  String describeItems() {
    String description = '';
    for(Item item in cart.items){
      description += item.inventory.product.name;
      description += " ${item.quantity} ,";
    }
    return description;
  }
}
