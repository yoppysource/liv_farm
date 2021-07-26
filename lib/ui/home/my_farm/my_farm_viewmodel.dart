import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/address_select/address_select_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MyFarmViewModel extends BaseViewModel {
  UserProviderService _userProviderService = locator<UserProviderService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DialogService _dialogService = locator<DialogService>();
  ServerService _serverService = locator<ServerService>();
  SecureStorageService _secureStorageService = locator<SecureStorageService>();
  bool isBusy = false;
  Future<void> onTapLogout() async {
    await _userProviderService.logout();
    _navigationService.replaceWith(Routes.homeView);
  }

  void onTapCustomerService() {
    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.CustomerService);
  }

  Future<void> onPressChangePassword() async {
    if (_userProviderService.user.snsId != null &&
        _userProviderService.user.platform != null) {
      return await _dialogService.showDialog(
        title: '오류',
        description: "소셜 로그인에서는 지원하지 않는 기능입니다",
        buttonTitle: '확인',
        barrierDismissible: false,
      );
    }
    SheetResponse _response = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.ChangePassword);
    String currentPassword = _response.responseData['currentPassword'];
    String newPassword = _response.responseData['newPassword'];
    if (currentPassword == null ||
        currentPassword == '' ||
        newPassword == null ||
        newPassword == '') {
      await _dialogService.showDialog(
        title: '오류',
        description: "비밀번호 형식이 올바르지 않습니다 다시 시도해주세요",
        buttonTitle: '확인',
        barrierDismissible: false,
      );
    } else {
      isBusy = true;
      notifyListeners();
      try {
        Map<String, dynamic> data = await _serverService.postData(
            resource: Resource.users,
            path: "/updateMyPassword",
            data: {
              "currentPassword": currentPassword,
              "newPassword": newPassword
            },
            isOtherDataNeed: true);
        if (data['token'] != null) {
          ServerService.accessToken = data['token'];
          await _secureStorageService.deleteTokenFromStorage();
          await _secureStorageService.storeTokenToStorage(token: data['token']);
          await _dialogService.showDialog(
            title: '안내',
            description: '비밀번호가 변경되었습니다',
            buttonTitle: '확인',
            barrierDismissible: false,
          );
        }
      isBusy = false;
      notifyListeners();
      } catch (e) {
        if (e.message != null) {
          _dialogService.showDialog(
            title: '오류',
            description: e.message,
            buttonTitle: '확인',
            barrierDismissible: false,
          );
        }
      isBusy = false;
      notifyListeners();
      }
    }
  }

  Future<void> onPressedCouponSelect() async {
    await _navigationService.navigateTo(Routes.couponView);
  }

  void onPressedAddressSelect() {
    _navigationService.navigateToView(AddressSelectView());
  }
}
