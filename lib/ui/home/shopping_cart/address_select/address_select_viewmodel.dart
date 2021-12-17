// import 'package:kopo/kopo.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/services/in_offine_store_service.dart';
import 'package:liv_farm/services/store_provider_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/address_select/daum_postcode_search_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddressSelectViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  UserProviderService _userProviderService = locator<UserProviderService>();
  DialogService _dialogService = locator<DialogService>();
  StoreProviderService _storeProviderService = locator<StoreProviderService>();
  InOffineStoreService _inOffineStoreService = locator<InOffineStoreService>();
  // KopoModel _kopoModel;
  List<Address> get addresses => _userProviderService.user.addresses;
  bool isBusy = false;

  void onPressedBack() {
    _navigationService.back();
  }

  Future<void> onPressedDelete(Address address) async {
    isBusy = true;
    notifyListeners();
    _userProviderService.user.addresses.remove(address);
    await _userProviderService.updateUserToServer();
    if (_userProviderService.user.addresses.isNotEmpty) {
      Address newAddress = _userProviderService.user.addresses[0];
      await _storeProviderService.getStoreDataFromServer(
          address: newAddress.address,
          coordinates: newAddress?.coordinates ?? []);
    } else {
      await _storeProviderService.getStoreDataFromServer();
    }
    isBusy = false;
    notifyListeners();
  }

  Future onPressedSearch() async {
    try {
      dynamic data =
          await _navigationService.navigateToView(DaumPostcodeSearchView());
      print(data);
      if (data != null) {
        isBusy = true;
        notifyListeners();
        await _storeProviderService.getStoreDataFromServer(
            address: data['address'], fromAddressSearch: true);
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

  Future<void> onPressedAddressTile(Address address) async {
    isBusy = true;
    notifyListeners();
    try {
      _userProviderService.user.addresses.remove(address);
      _userProviderService.user.addresses.insert(0, address);
      await _userProviderService.updateUserToServer();
      await _storeProviderService.getStoreDataFromServer(
          address: address.address, coordinates: address?.coordinates ?? []);
      _navigationService.back();
      isBusy = false;
      notifyListeners();
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
}
