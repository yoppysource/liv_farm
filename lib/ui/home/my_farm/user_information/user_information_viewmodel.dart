import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';

import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/platform_widget/platform_date_picker.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserInformationViewModel extends BaseViewModel with Formatter {
  UserProviderService _userProviderService = locator<UserProviderService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  String get name =>
      getStringOrDefaultString(_userProviderService.user.name, '성함');
  String get phoneNumber =>
      getStringOrDefaultString(_userProviderService.user.phoneNumber, '전화번호');
  String get email => _userProviderService.user.email;
  String get logoPathForPlatform {
    switch (_userProviderService.user.platform) {
      case ('kakao'):
        return "assets/images/kakao_icon.png";
      case ('apple'):
        return "assets/images/apple_icon.png";
      case ('facebook'):
        return "assets/images/facebook_icon.png";
      case ('google'):
        return "assets/images/google_icon.png";
      default:
        return "assets/images/app_icon.png";
    }
  }

  String get gender => _userProviderService.user.gender;
  String get birthday => _userProviderService.user.birthday == null
      ? '생년월일을 입력해주세요'
      : getStringFromDatetime(_userProviderService.user.birthday);

  String getStringOrDefaultString(String value, String title) {
    if (value == null || value == '') {
      return "$title을/를 입력해주세요";
    } else {
      return value;
    }
  }

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
      await _userProviderService.updateUserToServer();
      notifyListeners();
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
      await _userProviderService.updateUserToServer();
      notifyListeners();
    }
  }

  Future<void> callDateTimePickerForBirthDay(BuildContext context) async {
    DateTime value = await PlatformDatePicker(
      initialDate: (_userProviderService.user?.birthday == null)
          ? DateTime(1993, 09, 08)
          : _userProviderService.user?.birthday,
      onDateTimeChanged: (dateTime) {
        notifyListeners();
      },
    ).show(context);
    if (value != null) {
      _userProviderService.user?.birthday = value;
      notifyListeners();
      _userProviderService.updateUserToServer();
      notifyListeners();
    }
  }

  Future callBottomSheetForSelectingGender() async {
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.GetGender,
        customData: {'gender': _userProviderService.user.gender},
        title: '전화번호');
    if (_sheetResponse.confirmed)
      _userProviderService.user.gender = _sheetResponse.responseData['input'];
    notifyListeners();
    await _userProviderService.updateUserToServer();
    notifyListeners();
  }
}
