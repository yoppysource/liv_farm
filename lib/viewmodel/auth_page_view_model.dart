import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/repository/auth_page_repository/apple_auth_repository.dart';
import 'package:liv_farm/repository/auth_page_repository/auth_page_repository.dart';
import 'package:liv_farm/repository/auth_page_repository/facebook_auth_repository.dart';
import 'package:liv_farm/repository/auth_page_repository/google_auth_repository.dart';
import 'package:liv_farm/repository/auth_page_repository/kakao_auth_repository.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/platform_exception_alert_dialog.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';

class AuthPageViewmodel with ChangeNotifier {
  bool isWorking = true;
  LandingPageViewModel model;
  bool isApple = false;
  AuthPageRepository _authPageRepository = AuthPageRepository();
  KaKaoAuthRepository _kaKaoAuthRepository = KaKaoAuthRepository();
  GoogleAuthRepository _googleAuthRepository = GoogleAuthRepository();
  AppleAuthRepository _appleAuthRepository = AppleAuthRepository();

  FacebookAuthRepository _facebookAuthRepository = FacebookAuthRepository();
  AuthPageViewmodel(model) {
    log.methodLog(method: 'Init AuthPageViewmodel');
    this.model = model;
    Future.microtask(() async => await initAuth());
  }

  Map<String, dynamic> initialData;
  Future<void> initAuth() async {
    try {
      bool value = await AppleSignIn.isAvailable();
      if (value) {
        isApple = true;

      }
    } catch (e) {
      isApple = false;
    }
    await Firebase.initializeApp();
    log.methodLog(method: 'notifyListeners AuthPageViewmodel');
    isWorking = false;
    notifyListeners();
  }

  Future<void> onPressed(Future<Map<String, dynamic>> getDataFromPackage,
      BuildContext context) async {
    print('dsd');
    isWorking = true;
    notifyListeners();
    initialData = await getDataFromPackage;
    if (initialData == null) {
      isWorking = false;
      notifyListeners();
      PlatformExceptionAlertDialog(title: '오류', content: '소셜 로그인이 실패하셨습니다.')
          .show(context);
      return;
    }
    MyUser user = await _authPageRepository.getMyUserFromServer(initialData);
    if (user == null) {
      isWorking = false;
      notifyListeners();
      PlatformExceptionAlertDialog(title: '오류', content: '서버에 접속을 실패하셨습니다.')
          .show(context);
      return;
    }
    isWorking = await _authPageRepository.saveAccessTokenToLocal();
    if (isWorking == false) {
      isWorking = false;
      notifyListeners();
      PlatformExceptionAlertDialog(
              title: '오류', content: '로컬 서비스와 연동 중 오류가 났습니다.')
          .show(context);
      return;
    }
    isWorking = false;
    if (user != null) {
      //TODO: 죄책감... no other way...
      model.userStatusChanged(user);
      log.methodLog(method: 'notifyListeners In LandingPageViewModel called');
    }
    return;
  }

  Future<void> onPressedKakao(BuildContext context) async => await onPressed(
        _kaKaoAuthRepository.getInitialDataFromPackage(),
        context,
      );
  Future<void> onPressedGoogle(BuildContext context) async => await onPressed(
    _googleAuthRepository.getInitialDataFromPackage(),
    context,
  );

Future<void> onPressedFacebook(BuildContext context) async => await onPressed(
      _facebookAuthRepository.getInitialDataFromPackage(),
      context,
    );

  Future<void> onPressedApple(BuildContext context) async => await onPressed(
    _appleAuthRepository.getInitialDataFromPackage(),
    context,
  );
}
