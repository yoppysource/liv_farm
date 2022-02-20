import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/server_service/api_exception.dart';
import 'package:liv_farm/services/store_provider_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/address_select/daum_postcode_search_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;

class AddressSelectViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserProviderService _userProviderService =
      locator<UserProviderService>();
  final DialogService _dialogService = locator<DialogService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final StoreProviderService _storeProviderService =
      locator<StoreProviderService>();
  List<Address> get addresses => _userProviderService.user!.addresses!;

  @override
  bool isBusy = false;

  void onPressedBack() {
    _navigationService.back();
  }

  Future<Address> getCoordinatesFromServer(Address address) async {
    try {
      http.Response response = await http.get(
        Uri.https('dapi.kakao.com', '/v2/local/search/address.json', {
          "query": address.address,
        }),
        headers: {"Authorization": kakaoAddressKey},
      );
      if (!response.statusCode.toString().startsWith("2")) {
        throw APIException(response.statusCode, "오류가 발생했습니다");
      }
      final Map<String, dynamic> result =
          await jsonDecode(response.body) as Map<String, dynamic>;

      address.coordinates!.add(double.tryParse(result["documents"][0]["x"])!);
      address.coordinates!.add(double.tryParse(result["documents"][0]["y"])!);

      return address;
    } catch (e) {
      rethrow;
    }
  }

  Future onPressedSearch() async {
    try {
      dynamic data = await _navigationService
          .navigateToView(const DaumPostcodeSearchView());
      if (data != null) {
        isBusy = true;
        notifyListeners();
        String addressDetail = await callBottomSheetToGetAddressDetail();
        Address address = Address(
          address: data['address'],
          postcode: data['zonecode'],
          addressDetail: addressDetail,
          coordinates: [],
        );
        await getCoordinatesFromServer(address);
        await _userProviderService.appendAddress(address);
        await _storeProviderService.setStoresWhenAddressChange(address);
        isBusy = false;
        notifyListeners();
        _navigationService.back();
      }
    } catch (e) {
      await _dialogService.showDialog(
        title: '오류',
        description: "주소 등록 중 오류가 발생했습니다 다시 시도해주세요",
        buttonTitle: '확인',
        barrierDismissible: false,
      );
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> onPressedDelete(Address address, int index) async {
    isBusy = true;
    notifyListeners();
    try {
      _userProviderService.user!.addresses!.remove(address);
      await _userProviderService.updateUserToServer();
      if (index == 0 && _userProviderService.user!.addresses!.isNotEmpty) {
        await _storeProviderService.setStoresWhenAddressChange(
            _userProviderService.user!.addresses![0]);
      }
    } catch (e) {
      await _dialogService.showDialog(
        title: '오류',
        description: "주소 삭제 중 오류가 발생했습니다 다시 시도해주세요",
        buttonTitle: '확인',
        barrierDismissible: false,
      );
    }
    isBusy = false;
    notifyListeners();
  }

  Future<void> onPressedAddressTile(Address address, int index) async {
    isBusy = true;
    notifyListeners();
    try {
      if (index != 0) {
        _userProviderService.user!.addresses!.remove(address);
        _userProviderService.user!.addresses!.insert(0, address);
        await _userProviderService.updateUserToServer();
        await _storeProviderService.setStoresWhenAddressChange(address);
      }
      _navigationService.back();
    } catch (e) {
      await _dialogService.showDialog(
        title: '오류',
        description: "주소 등록 중 오류가 발생했습니다 다시 시도해주세요",
        buttonTitle: '확인',
        barrierDismissible: false,
      );
    }
    isBusy = false;
    notifyListeners();
  }

  Future<String> callBottomSheetToGetAddressDetail() async {
    SheetResponse? _sheetResponse = await _bottomSheetService
        .showCustomSheet<dynamic, Map<String, dynamic>>(
            variant: BottomSheetType.Write,
            data: {
              'maxLength': 20,
              'keyboardType': TextInputType.streetAddress,
              'hintText': '상세주소를 입력해주세요'
            },
            title: '상세주소');
    if (_sheetResponse != null && _sheetResponse.confirmed) {
      return _sheetResponse.data['input'].trim();
    } else {
      DialogResponse? res = await _dialogService.showConfirmationDialog(
          title: "알림",
          description: "상세주소는 안전한 배송을 위해서 필수사항입니다.정말 건너뛰시겠습니까?",
          barrierDismissible: false,
          confirmationTitle: "기입하기",
          cancelTitle: "건너뛰기");
      if (res != null && res.confirmed) {
        return callBottomSheetToGetAddressDetail();
      } else {
        return '';
      }
    }
  }
}
