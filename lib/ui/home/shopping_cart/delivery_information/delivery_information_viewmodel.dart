import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DeliveryInformationViewModel extends BaseViewModel {
  UserProviderService _userProviderService = locator<UserProviderService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  ShoppingCartViewModel _shoppingCartViewModel =
      locator<ShoppingCartViewModel>();

  String get name => (_userProviderService.user.name == null ||
          _userProviderService.user.name == '')
      ? '이름을 입력해주세요'
      : _userProviderService.user.name;
  String get phoneNumber => (_userProviderService.user.phoneNumber == null ||
          _userProviderService.user.phoneNumber == '')
      ? '전화번호를 입력해주세요'
      : _userProviderService.user.phoneNumber;

  Future<void> callBottomSheetToGetName() async {
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        customData: {'maxLength': 5, 'text': _userProviderService.user.name},
        title: '성함');
    if (_sheetResponse.confirmed) {
      _userProviderService.user.name =
          _sheetResponse.responseData['input'].trim();
      notifyListeners();
      _shoppingCartViewModel.rebuild();
      await _userProviderService.updateUserToServer();
    }
  }

  Future<void> callBottomSheetToGetPhoneNumber() async {
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        customData: {
          'maxLength': 11,
          'text': _userProviderService.user.phoneNumber,
          'keyboardType': TextInputType.phone,
          'hintText': '- 없이 숫자만 입력해주세요'
        },
        title: '전화번호');
    if (_sheetResponse.confirmed) {
      _userProviderService.user.phoneNumber =
          _sheetResponse.responseData['input'].trim();
      notifyListeners();
      _shoppingCartViewModel.rebuild();
      await _userProviderService.updateUserToServer();
    }
  }
}
