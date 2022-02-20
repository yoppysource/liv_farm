import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/server_service/api_exception.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CouponViewModel extends BaseViewModel {
  final UserProviderService _userProviderService =
      locator<UserProviderService>();
  List<Coupon> get couponList => _userProviderService.user!.coupons;
  int? selectedIndex;
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ClientService _serverService = locator<ClientService>();
  final CartProviderService _cartProviderService =
      locator<CartProviderService>();
  @override
  bool isBusy = false;

  CouponViewModel() {
    _cartProviderService.selectedCoupon = null;
  }

  void onBackPressed() {
    _navigationService.back();
  }

  void onPressedApply() {
    _cartProviderService.selectedCoupon = couponList[selectedIndex!];
    _navigationService.back();
  }

  Future<void> registerCoupon() async {
    SheetResponse? _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        data: {'maxLength': 5, "hintText": '쿠폰 코드를 입력해주세요'},
        title: '쿠폰등록');
    if (_sheetResponse != null && _sheetResponse.confirmed) {
      try {
        isBusy = true;
        notifyListeners();
        await _serverService.sendRequest(
            method: HttpMethod.post,
            resource: Resource.coupons,
            endPath:
                "/register/${_sheetResponse.responseData['input'].trim().toLowerCase()}");
        // await _serverService.postData();
        await _userProviderService.syncUserFromServer();
        ToastMessageService.showToast(message: "쿠폰이 정상적으로 등록되었습니다");
      } on APIException catch (e) {
        ToastMessageService.showToast(message: e.message.toString());
      } catch (e) {
        ToastMessageService.showToast(message: "쿠폰 등록에 실패하셨습니다");
      }
      isBusy = false;
      notifyListeners();
    }
  }

  void selectCoupon(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
