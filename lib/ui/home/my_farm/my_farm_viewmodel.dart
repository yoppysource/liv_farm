import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/address_select/address_select_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MyFarmViewModel extends BaseViewModel {
  UserProviderService _userProviderService = locator<UserProviderService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  Future<void> onTapLogout() async {
    await _userProviderService.logout();

    _navigationService.replaceWith(Routes.homeView);
  }

  void onTapCustomerService() {
    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.CustomerService);
  }

  void onPressedAddressSelect() {
    _navigationService.navigateToView(AddressSelectView());
  }
}
