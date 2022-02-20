import 'dart:async';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/option_group.dart';
import 'package:liv_farm/model/order.dart';
import 'package:liv_farm/model/store.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/cart_validation_service/cart_request_validation_exception.dart';
import 'package:liv_farm/services/cart_validation_service/cart_validation_service.dart';
import 'package:liv_farm/services/cart_validation_service/model/cart_request.dart';
import 'package:liv_farm/services/server_service/api_exception.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
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
import 'package:liv_farm/util/date_time_extension.dart';

class ShoppingCartViewModel extends ReactiveViewModel {
  final UserProviderService _userProviderService =
      locator<UserProviderService>();
  final DialogService _dialogService = locator<DialogService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final CartProviderService _cartProviderService =
      locator<CartProviderService>();
  final ClientService _serverService = locator<ClientService>();
  final StoreProviderService _storeProviderService =
      locator<StoreProviderService>();
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_cartProviderService];

  CartRequest get cartRequest => CartRequest(
        amount: _cartProviderService.cart!.totalPrice,
        isDelivery: !_cartProviderService.takeout,
        name: _userProviderService.user?.name ?? "",
        phoneNumber: _userProviderService.user?.phoneNumber ?? "",
        address: _userProviderService.user!.addresses!.isEmpty
            ? ""
            : _userProviderService.user!.addresses![0].address,
      );
  CartValidationService get cartValidationService =>
      CartValidationService.withStore(_storeProviderService.store!);

  List<CartRequestValidationException> get exceptionList {
    List<CartRequestValidationException> myList = [];
    cartValidationService.validate(cartRequest).fold(
        (Iterable<CartRequestValidationException> l) => myList.addAll(l),
        (_) {});
    return myList;
  }

  //Onpressed On order
  String get purchaseButtonMessage => exceptionList.isEmpty
      ? (_caluator.availableNow &&
              _cartProviderService.bookingOrderDateTime == null)
          ? "결제하기"
          : "예약주문하기"
      : exceptionList[0].message;

  late DateTime _now;
  late OrderReservationCaluator _caluator;

  ShoppingCartViewModel() {
    _now = DateTime.now();
    _caluator = OrderReservationCaluator(
        store: locator<StoreProviderService>().store!, now: _now);
  }

  Store? get store => _storeProviderService.store;
  bool get takeOut => store!.takeOut && _cartProviderService.takeout;
  int get availablePoint => _userProviderService.user!.point;
  int pointInput = 0;

  String get bannerText {
    if (!takeOut) {
      if (_userProviderService.user!.addresses!.isEmpty) {
        return "배송지를 입력해주세요";
      } else if (!_storeProviderService.store!.availableForDelivery!) {
        return "배송이 불가능한 지역입니다.";
      }
    }
    return "${_storeProviderService.store!.name}에서 수확합니다";
  }

  Address? get selectedAddress =>
      _userProviderService.user!.addresses!.isNotEmpty
          ? _userProviderService.user!.addresses![0]
          : null;
  //About Cart
  Cart get cart => _cartProviderService.cart!;
  int get cartLength => cart.items.length;
  String get deliveryRequestMessage => _cartProviderService.orderRequestMessage;
  Coupon? get selectedCoupon => _cartProviderService.selectedCoupon;

  String get defaultOrderTimeMessage {
    if (_caluator.availableNow) {
      return takeOut ? "30분 이내 도착 후 수령" : "주문 후 바로 수확하여 배송";
    } else if (_caluator.dateTimePairedWithTimeOfDayList!.keys.first.day ==
        _now.day) {
      return "오늘 오픈시간(${_storeProviderService.store!.openHourStr})에 ${takeOut ? "수령" : "배송"}";
    } else {
      return "${_caluator.dateTimePairedWithTimeOfDayList!.keys.first.day}일 (${_caluator.dateTimePairedWithTimeOfDayList!.keys.first.weekdayInKor}) 오픈시간(${_storeProviderService.store!.openHourStr})에 ${takeOut ? "수령" : "배송"}";
    }
  }

  String get orderTimeMessage => _cartProviderService.bookingOrderDateTime ==
          null
      ? defaultOrderTimeMessage
      : "${_cartProviderService.bookingOrderDateTime!.day}일(${_cartProviderService.bookingOrderDateTime!.weekdayInKor[0]}) ${_cartProviderService.bookingOrderDateTime!.hour}시${_cartProviderService.bookingOrderDateTime!.minute == 0 ? '' : " " + _cartProviderService.bookingOrderDateTime!.minute.toString() + '분'}에 받기";
  int get deliveryFee => takeOut == true ? 0 : store!.deliveryFee;
  int get totalProductPrice => _cartProviderService.cart!.totalPrice;

  int get _couponDiscountAmount =>
      (_cartProviderService.selectedCoupon != null &&
              _cartProviderService.selectedCoupon!.amount < totalProductPrice)
          ? _cartProviderService.selectedCoupon!.amount
          : 0;

  bool get isCouponAmountExceedDiscountedPrice =>
      (_cartProviderService.selectedCoupon != null &&
          _cartProviderService.selectedCoupon!.amount > totalProductPrice);

  bool get isInputPointAmountExceedCouponAppliedPrice => (pointInput != 0 &&
      pointInput >= totalProductPrice - _couponDiscountAmount);

  int get paymentAmount {
    int productPrice = totalProductPrice;
    productPrice -= _couponDiscountAmount;
    if (pointInput != 0 && !isInputPointAmountExceedCouponAppliedPrice) {
      productPrice -= pointInput;
    }

    return productPrice + deliveryFee;
  }

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
        Map<String, dynamic> data = await _serverService.sendRequest(
            method: HttpMethod.patch,
            resource: Resource.carts,
            endPath: '/my/item',
            data: item.toJson());
        _cartProviderService.syncCartFromJson(data);
        notifyListeners();
      } else {
        ToastMessageService.showToast(message: "재고가 부족합니다");
      }
    } on APIException catch (e) {
      _dialogService.showDialog(
          title: '오류',
          description: e.message.toString(),
          barrierDismissible: true,
          buttonTitle: '확인');
    } catch (e) {
      _dialogService.showDialog(
          title: '오류',
          description: e.toString(),
          barrierDismissible: true,
          buttonTitle: '확인');
    }
  }

  Future<void> decreaseItemQuantity(Item item) async {
    try {
      item.quantity -= 1;
      notifyListeners();
      Map<String, dynamic> data = await _serverService.sendRequest(
          method: HttpMethod.patch,
          resource: Resource.carts,
          endPath: '/my/item',
          data: item.toJson());
      _cartProviderService.syncCartFromJson(data);
      notifyListeners();
    } on APIException catch (e) {
      _dialogService.showDialog(
          title: '오류',
          description: e.message.toString(),
          barrierDismissible: true,
          buttonTitle: '확인');
    } catch (e) {
      _dialogService.showDialog(
          title: '오류',
          description: "오류가 발생했습니다.",
          barrierDismissible: true,
          buttonTitle: '확인');
    }
  }

  Future<void> removeFromCart(Item item) async {
    try {
      cart.items.remove(item);
      notifyListeners();
      Map<String, dynamic> data = await _serverService.sendRequest(
          method: HttpMethod.post,
          resource: Resource.carts,
          endPath: '/my/item/delete',
          data: item.toJson());
      _cartProviderService.syncCartFromJson(data);
      notifyListeners();
    } on APIException catch (e) {
      _dialogService.showDialog(
          title: '오류',
          description: e.message.toString(),
          barrierDismissible: true,
          buttonTitle: '확인');
    } catch (e) {
      _dialogService.showDialog(
          title: '오류',
          description: "오류가 발생했습니다.",
          barrierDismissible: true,
          buttonTitle: '확인');
    }
    notifyListeners();
  }

  Future<void> onPressPointInput() async {
    if (availablePoint <= 1000) {
      _dialogService.showDialog(
          title: '오류',
          description: "포인트는 1000점 이상부터 사용 가능합니다.",
          buttonTitle: '확인');
      return;
    }
    pointInput = 0;
    SheetResponse? _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.PointInput,
        data: {"availablePoint": availablePoint},
        title: '사용가능 포인트: $availablePoint점');
    if (_sheetResponse != null && _sheetResponse.confirmed) {
      pointInput = _sheetResponse.data['pointInput'];
    }
    notifyListeners();
  }

  Future<void> callBottomSheetToGetInput() async {
    SheetResponse? _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        data: {
          'maxLength': 50,
          'text': _cartProviderService.orderRequestMessage,
        },
        title: '요청사항');
    if (_sheetResponse != null && _sheetResponse.confirmed) {
      _cartProviderService.orderRequestMessage = _sheetResponse.data['input'];
    }
    notifyListeners();
  }

  Future callBottomSheetToGetDateTime() async {
    if (isBusy == true) return;
    _cartProviderService.bookingOrderDateTime = null;
    SheetResponse? _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.GetDateTime,
        title: orderTimeMessage,
        data: _caluator.dateTimePairedWithTimeOfDayList);
    if (_sheetResponse != null && _sheetResponse.confirmed) {
      _cartProviderService.bookingOrderDateTime = _sheetResponse
          .data[PickDateTimeBottomSheetViewModel.KEY_selectedDate];
      notifyListeners();
    }
  }

  Future<void> onPressedCouponSelect() async {
    await _navigationService.navigateTo(Routes.couponView);
    notifyListeners();
  }

  Future<void> onPressedAddress() async {
    await _navigationService.navigateToView(const AddressSelectView());
    notifyListeners();
  }

  bool get isPossibleToPurchase => exceptionList.isEmpty;

  Future<void> onPressedOnPayment() async {
    List<String> runOutItemNamesList = [];
    for (var item in cart.items) {
      if (item.quantity > item.inventory.inventory) {
        runOutItemNamesList.add(item.inventory.product.name);
      }
    }
    if (runOutItemNamesList.isNotEmpty) {
      String nameList = runOutItemNamesList.toString();
      _dialogService.showDialog(
          title: '재고 부족',
          description:
              '${nameList.substring(1, nameList.length - 1)} 재고가 부족합니다',
          buttonTitle: '확인');
      return;
    }

    String? paymentOption = await _navigationService.navigateWithTransition(
        PurchaseOptionView(
          orderName:
              "${cart.items[0].inventory.product.name} 포함 ${cart.items.length}건에 대한 주문",
          amount: paymentAmount,
          address: selectedAddress!,
          orderRequestMessage: _cartProviderService.orderRequestMessage,
          bookingOrderMessage: orderTimeMessage,
          option: takeOut ? 'takeOut' : 'delivery',
        ),
        transition: 'fade');
    if (paymentOption == null) {
      _dialogService.showDialog(
          title: '취소', description: '결제를 취소하셨습니다', buttonTitle: '확인');
      return;
    }

    String orderId =
        "${_userProviderService.user!.id}_${DateTime.now().millisecondsSinceEpoch}";

    PaymentData paymentData = PaymentData(
      pg: paymentOption,
      payMethod: paymentOption == "kakaopay" ? "kakaopay" : "card",
      merchantUid: orderId,
      amount: 10,
      buyerTel: _userProviderService.user!.phoneNumber!,
      buyerName: _userProviderService.user!.name,
      buyerEmail: _userProviderService.user!.email,
      buyerAddr: takeOut
          ? null
          : "${selectedAddress!.address} ${selectedAddress?.addressDetail ?? ""}",
      buyerPostcode: takeOut ? null : selectedAddress!.postcode,
      appScheme: "livFarm",
      name:
          "${cart.items[0].inventory.product.name} 포함 ${cart.items.length}건에 대한 주문",
      customData: <String, String>{
        "option": takeOut ? "takeOut" : "delivery",
        "storeAddress": _storeProviderService.store!.address,
        "bookingOrderMessage": orderTimeMessage,
        "orderRequestMessage": _cartProviderService.orderRequestMessage,
        "customerId": _userProviderService.user!.id,
        "cartId": cart.id,
        "items": describeItems(),
      },
    );
    await _navigationService.navigateWithTransition(
        PurchaseView(
            paymentData: paymentData,
            order: Order(
                isReviewed: false,
                id: orderId,
                orderTitle:
                    "${cart.items[0].inventory.product.name} 포함 ${cart.items.length}건에 대한 주문",
                status: 0,
                option: takeOut ? "takeOut" : "delivery",
                bookingOrderMessage: orderTimeMessage,
                address: selectedAddress!,
                createdAt: DateTime.now(),
                cart: cart,
                storeId: cart.storeId!,
                paidAmount: paymentAmount,
                user: _userProviderService.user!,
                payMethod: "card",
                usedPoint: (pointInput == 0 ||
                        isInputPointAmountExceedCouponAppliedPrice)
                    ? 0
                    : pointInput,
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
    for (int i = 0; i < cart.items.length; i++) {
      description += cart.items[i].inventory.product.name;
      if (cart.items[i].options.isNotEmpty) {
        description += "(";
        for (Option option in cart.items[i].options) {
          description += option.name;
          description += " ";
        }
        description += ")";
      }
      description += "수량: ${cart.items[i].quantity}";
      if (i != cart.items.length - 1) description += ", ";
    }
    return description;
  }
}
