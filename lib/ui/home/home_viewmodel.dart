import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserProviderService _userProviderService =
      locator<UserProviderService>();
  final DialogService _dialogService = locator<DialogService>();
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  bool isIndexSelected(int index) => _currentIndex == index;
  bool _reverse = false;
  get isLogined => _userProviderService.isLogined;
  bool get reverse => _reverse;

  Future<void> setIndex(int value) async {
    if (!isLogined && value > 1) {
      DialogResponse? pressYes = await _dialogService.showConfirmationDialog(
        title: '로그인이 필요합니다',
        description: '로그인 또는 회원가입을 하시겠습니까?',
        cancelTitle: '취소',
        confirmationTitle: '로그인하기',
        barrierDismissible: true,
      );
      if (pressYes?.confirmed ?? false) {
        _navigationService.navigateTo(Routes.loginView);
      }
      return;
    }
    if (value < _currentIndex) {
      _reverse = true;
    } else {
      _reverse = false;
    }
    _currentIndex = value;
    notifyListeners();
  }
}
