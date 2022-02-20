// import 'package:liv_farm/app/app.locator.dart';
// import 'package:liv_farm/model/address.dart';
// import 'package:liv_farm/services/in_offine_store_service.dart';
// import 'package:liv_farm/services/user_provider_service.dart';
// import 'package:stacked/stacked.dart';
// import 'package:stacked_services/stacked_services.dart';
// import 'package:liv_farm/app/app.router.dart';

// class OfflineStoreAppbarViewModel extends BaseViewModel {
//   final NavigationService _navigationService = locator<NavigationService>();
//   final InOffineStoreService _inOffineStoreService =
//       locator<InOffineStoreService>();
//   final UserProviderService _userProviderService =
//       locator<UserProviderService>();
//   final DialogService _dialogService = locator<DialogService>();

//   Address get selectedAddress => _userProviderService.user.addresses.isNotEmpty
//       ? _userProviderService.user.addresses[0]
//       : null;

//   Future<void> onPressed() async {
//     DialogResponse _response = await _dialogService.showDialog(
//       title: '종료',
//       description: '매장 내 물품 스캔을 중단 하시겠습니까?',
//       cancelTitle: '아니오',
//       buttonTitle: '종료',
//       barrierDismissible: true,
//     );
//     if (_response.confirmed) {
//       await _inOffineStoreService.backToOnlineMode();
//       _navigationService.navigateTo(Routes.landingView);
//     }
//   }
// }
