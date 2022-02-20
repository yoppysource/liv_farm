import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DeliveryInformationViewModel extends BaseViewModel {
  final UserProviderService _userProviderService =
      locator<UserProviderService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  String get name => (_userProviderService.user!.name == null ||
          _userProviderService.user!.name == '')
      ? '이름을 입력해주세요'
      : _userProviderService.user!.name!;
  String get phoneNumber => (_userProviderService.user!.phoneNumber == null ||
          _userProviderService.user!.phoneNumber == '')
      ? '전화번호를 입력해주세요'
      : _userProviderService.user!.phoneNumber!;

  Future<void> callBottomSheetToGetName() async {
    SheetResponse? _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        data: {'maxLength': 5, 'text': _userProviderService.user!.name},
        title: '성함');
    if (_sheetResponse != null && _sheetResponse.confirmed) {
      _userProviderService.user!.name = _sheetResponse.data['input'].trim();
      notifyListeners();

      await _userProviderService.updateUserToServer();
    }
  }

  Future<void> callBottomSheetToGetPhoneNumber() async {
    SheetResponse? _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        data: {
          'maxLength': 11,
          'text': _userProviderService.user!.phoneNumber,
          'keyboardType': TextInputType.phone,
          'hintText': '- 없이 숫자만 입력해주세요'
        },
        title: '전화번호');
    if (_sheetResponse != null && _sheetResponse.confirmed) {
      _userProviderService.user!.phoneNumber =
          _sheetResponse.data['input'].trim();
      notifyListeners();
      await _userProviderService.updateUserToServer();
    }
  }
}
