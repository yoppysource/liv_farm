import 'package:flutter/material.dart';
import 'package:kopo/kopo.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddressSelectViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  UserProviderService _userProviderService = locator<UserProviderService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DialogService _dialogService = locator<DialogService>();
  ShoppingCartViewModel _shoppingCartViewModel =
      locator<ShoppingCartViewModel>();
  KopoModel _kopoModel;
  List<Address> get addresses => _userProviderService.user.addresses;
  List<String> validAddress = [
    '위례',
    '복정',
    '태평',
    '양지',
    '단대',
    '여수',
    '하대원',
    '상대원',
    '중앙',
    '성남',
    '수진',
    '야탑',
    '이매',
    '삼평동',
    '도촌동',
    '은행',
    '금광',
    '산성',
    '신흥',
    '양지'
  ];
  bool isValid = false;
  Address selectedAddress;

  void onPressedBack() {
    _navigationService.back();
  }

  Future<void> onPressedDelete(index) async {
    Address selectedAddress = _userProviderService.user.addresses[index];
    _userProviderService.user.addresses.remove(selectedAddress);
    notifyListeners();
    _shoppingCartViewModel.rebuild();
    await _userProviderService.updateUserToServer();
  }

  Future onPressedSearch() async {
    _kopoModel = await _navigationService.navigateToView(Kopo());
    if (_kopoModel != null) {
      selectedAddress = Address(
        address: _kopoModel.address,
        postcode: _kopoModel.zonecode,
      );
      if (_kopoModel.jibunAddress.contains('성남')) {
        print(_kopoModel.toJson());
        validAddress.forEach((element) {
          if (_kopoModel.jibunAddress.contains(element)) {
            this.isValid = true;
            return;
          }
        });
      }
      if (isValid == false) {
        _dialogService.showDialog(
            title: "안내",
            description: '죄송합니다. 배송이 불가능한 지역입니다.',
            buttonTitle: "확인");
      } else {
        await callBottomSheetToGetAddressDetail();
        _userProviderService.user.addresses.insert(0, selectedAddress);
        _userProviderService.updateUserToServer();
        _shoppingCartViewModel.rebuild();
        _navigationService.back();
      }
    }
  }

  void onPressedAddressTile(int index) {
    selectedAddress = _userProviderService.user.addresses[index];
    _userProviderService.user.addresses.remove(selectedAddress);
    _userProviderService.user.addresses.insert(0, selectedAddress);
    _userProviderService.updateUserToServer();
    _shoppingCartViewModel.rebuild();
    _navigationService.back();
  }

  Future callBottomSheetToGetAddressDetail() async {
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.Write,
        customData: {
          'maxLength': 20,
          'keyboardType': TextInputType.streetAddress,
          'hintText': '상세주소를 입력해주세요'
        },
        title: '상세주소');
    if (_sheetResponse.confirmed) {
      this.selectedAddress.addressDetail =
          _sheetResponse.responseData['input'].trim();
    } else {
      DialogResponse res = await _dialogService.showConfirmationDialog(
          title: "알림",
          description: "상세주소는 안전한 배송을 위해서 필수사항입니다.정말 건너뛰시겠습니까?",
          barrierDismissible: false,
          confirmationTitle: "기입하기",
          cancelTitle: "건너뛰기");
      if (res.confirmed) return callBottomSheetToGetAddressDetail();
    }
  }
}
