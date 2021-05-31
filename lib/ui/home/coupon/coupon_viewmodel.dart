import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CouponViewModel extends BaseViewModel {
  UserProviderService _userProviderService = locator<UserProviderService>();
  List<Coupon> get couponList => _userProviderService.user.coupons;
  int selectedIndex;
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();
  ServerService _serverService =
      ServerService(apiPath: APIPath(resource: Resource.coupons));

  ShoppingCartViewModel _shoppingCartViewModel =
      locator<ShoppingCartViewModel>();

  CouponViewModel() {
    _shoppingCartViewModel.selectedCoupon = null;
  }

  void onBackPressed() {
    _navigationService.back();
  }

  void onPressedApply() {
    _shoppingCartViewModel.selectedCoupon = couponList[selectedIndex];
    _navigationService.back();
  }

  Future<void> registerCoupon() async {
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        customData: {'maxLength': 5, "hintText": '쿠폰 코드를 입력해주세요'},
        title: '쿠폰등록');
    if (_sheetResponse.confirmed) {
      try {
        await _serverService.postData(
            path:
                "/registerCoupon/${_sheetResponse.responseData['input'].trim().toLowerCase()}",
            data: Map());
        await _userProviderService.syncUserFromServer();
        notifyListeners();
        ToastMessageService.showToast(message: "쿠폰이 정상적으로 등록되었습니다");
      } on APIException catch (e) {
        ToastMessageService.showToast(message: e.message.toString());
      } catch (e) {
        ToastMessageService.showToast(message: "쿠폰 등록에 실패하셨습니다");
      }
    }
  }

  void selectCoupon(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
