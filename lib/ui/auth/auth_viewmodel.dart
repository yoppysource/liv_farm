import 'package:flutter/foundation.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/auth_service/auth_service.dart';
import 'package:liv_farm/services/auth_service/social_auth_service.dart';
import 'package:liv_farm/services/server_service/api_exception.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class AuthViewModel extends FormViewModel {
  final _navigationService = locator<NavigationService>();
  final UserProviderService _userProviderService =
      locator<UserProviderService>();
  final ClientService _serverService = locator<ClientService>();
  // StoreProviderService _storeProviderService = locator<StoreProviderService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final DialogService _dialogService = locator<DialogService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  bool isInputVaildToSubmit = false;
  @override
  bool isBusy = false;
  Future<void> onAuthPressed(AuthService _authService) async {
    try {
      isBusy = true;
      notifyListeners();
      await runBusyFuture(_authService.runAuth(), throwException: true);
      // agree to get mail is used for whether the user is new user or not
      _userProviderService.user!.agreeToGetMail == null
          ? await _analyticsService
              .logSignUp(_userProviderService.user!.platform ?? "livFarm")
          : await _analyticsService
              .logLogin(_userProviderService.user!.platform ?? "livFarm");
      bool isNewUser = _userProviderService.user!.agreeToGetMail == null;

      if (isNewUser || _userProviderService.user!.agreeToGetMail == false) {
        await _showDialogsForNewUser();
      }
      if (isNewUser) {
        await _bottomSheetService.showBottomSheet(
            title: "신규 고객 할인 쿠폰",
            description: "신규 가입을 축하합니다. 마이팜 -> 쿠폰함에서 가입 환영쿠폰을 확인하세요.",
            confirmButtonTitle: "확인");
      }
      if (_userProviderService.user!.isEmailConfirmed == false) {
        await _serverService.sendRequest(
            method: HttpMethod.post,
            resource: Resource.auth,
            endPath: '/confirmationEmail',
            data: {"email": _userProviderService.user!.email});
        await _dialogService.showDialog(
          title: '이메일 인증',
          description: "가입하신 이메일 메일함에서 이메일 주소를 인증하고, 다시 로그인해주세요",
          buttonTitle: '확인',
          barrierDismissible: false,
        );
        await _userProviderService.logout();
        _navigationService.replaceWith(Routes.homeView);
        return;
      }
      _navigationService.replaceWith(Routes.landingView);
    } on APIException catch (e) {
      isBusy = false;
      _dialogService.showDialog(
        title: '로그인 오류',
        description: e.message,
        buttonTitle: '확인',
        barrierDismissible: false,
      );
      // print(e.message);
      // setValidationMessage(e.message);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      isBusy = false;
      _dialogService.showDialog(
        title: '로그인 오류',
        description: "오류가 발생했습니다. 다음에 다시 시도해주세요",
        buttonTitle: '확인',
        barrierDismissible: false,
      );
      notifyListeners();
      // print(e.toString());
      // setValidationMessage("실패하셨습니다.");
    }
  }

  Future _showDialogsForNewUser() async {
    SheetResponse? _emailSendConfirmationResponse =
        await _bottomSheetService.showCustomSheet(
            isScrollControlled: true,
            variant: BottomSheetType.Basic,
            barrierDismissible: false,
            title: '이메일 알림 수신 설정',
            description: '고객님의 이메일로 리브팜의 쿠폰 및 프로모션 정보를 받아보시겠어요?',
            mainButtonTitle: '예, 받아보겠습니다',
            secondaryButtonTitle: '아니요');

    if (_emailSendConfirmationResponse != null &&
        _emailSendConfirmationResponse.confirmed) {
      _userProviderService.user!.agreeToGetMail = true;
    } else {
      _userProviderService.user!.agreeToGetMail = false;
    }
    await _userProviderService.updateUserToServer();
  }

  void onMainButtonPressed();
  void onBackButtonPressed() => _navigationService.back();
  void onToggleButtonPressed();

  Future<void> onKakaoPressed() async =>
      await onAuthPressed(KakaoAuthService());

  // Future<void> onFacebookPressed() async =>
  //     await onAuthPressed(FacebookAuthService());

  Future<void> onApplePressed() async =>
      await onAuthPressed(AppleAuthService());

  Future<void> onGooglePressed() async =>
      await onAuthPressed(GoogleAuthService());
}
