import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/auth_service/auth_service.dart';
import 'package:liv_farm/services/auth_service/social_auth_service.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class AuthViewModel extends FormViewModel {
  final _navigationService = locator<NavigationService>();
  UserProviderService _userProviderService = locator<UserProviderService>();
  final _bottomSheetService = locator<BottomSheetService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  bool isInputVaildToSubmit = false;
  Future<void> onAuthPressed(AuthService _authService) async {
    try {
      await runBusyFuture(_authService.runAuth(), throwException: true);

      _userProviderService.user.agreeToGetMail == null
          ? await _analyticsService
              .logSignUp(_userProviderService.user.platform)
          : await _analyticsService
              .logLogin(_userProviderService.user.platform);
      bool isNewUser = _userProviderService.user.agreeToGetMail == null;

      if (_userProviderService.user.agreeToGetMail == null ||
          _userProviderService.user.agreeToGetMail == false) {
        await _showDialogsForNewUser();
      }
      if (isNewUser) {
        await _bottomSheetService.showBottomSheet(
            title: "신규 고객 할인 쿠폰",
            description: "신규 가입을 축하합니다. 마이팜 -> 쿠폰함에서 가입 환영쿠폰을 확인하세요.",
            confirmButtonTitle: "확인");
      }

      _navigationService.replaceWith(Routes.homeView);
    } on APIException catch (e) {
      setValidationMessage(e.message);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      setValidationMessage("실패하셨습니다.");
    }
  }

  Future _showDialogsForNewUser() async {
    SheetResponse _emailAlarm = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Basic,
        barrierDismissible: false,
        title: '이메일 알림 수신 설정',
        description: '고객님의 이메일로 리브팜의 쿠폰 및 프로모션 정보를 받아보시겠어요?',
        mainButtonTitle: '예, 받아보겠습니다',
        secondaryButtonTitle: '아니요');
    if (_emailAlarm.confirmed) {
      _userProviderService.user.agreeToGetMail = true;
    } else {
      _userProviderService.user.agreeToGetMail = false;
    }
    print(_userProviderService.user.agreeToGetMail);
    await _userProviderService.updateUserToServer();
  }

  void onMainButtonPressed();
  void onBackButtonPressed() => _navigationService.back();
  void onToggleButtonPressed();

  Future<void> onKakaoPressed() async =>
      await onAuthPressed(KakaoAuthService());

  Future<void> onFacebookPressed() async =>
      await onAuthPressed(FacebookAuthService());

  Future<void> onApplePressed() async =>
      await onAuthPressed(AppleAuthService());

  Future<void> onGooglePressed() async =>
      await onAuthPressed(GoogleAuthService());
}
