import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/address_select/address_select_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddressAppBarViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  UserProviderService _userProviderService = locator<UserProviderService>();

  Address get selectedAddress => _userProviderService.user.addresses.isNotEmpty
      ? _userProviderService.user.addresses[0]
      : null;

  String get title {
    if (!_userProviderService.isLogined) {
      return '로그인을 해주세요';
    } else if (_userProviderService.user.addresses.isEmpty) {
      return '주소를 입력해주세요';
    } else {
      return '${selectedAddress.address} ${selectedAddress.addressDetail == null ? "" : selectedAddress.addressDetail.length > 7 ? "" : selectedAddress.addressDetail}';
    }
  }

  Future<void> onPressed() async {
    if (!_userProviderService.isLogined) return;
    await _navigationService.navigateToView(AddressSelectView());
    notifyListeners();
  }
}
