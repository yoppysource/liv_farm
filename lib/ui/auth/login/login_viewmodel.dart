import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/services/auth_service/user_input_auth_service.dart';
import 'package:liv_farm/services/server_service/api_exception.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/ui/auth/auth_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked_services/stacked_services.dart';

import 'login_view.form.dart';

class LoginViewModel extends AuthViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserInputAuthService _userInputAuthService =
      UserInputAuthService(isSignup: false);
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final DialogService _dialogService = locator<DialogService>();
  final ClientService _serverService = locator<ClientService>();

  @override
  Future<void> onMainButtonPressed() async {
    _userInputAuthService.email = emailValue?.trim() ?? '';
    _userInputAuthService.password = passwordValue?.trim() ?? '';
    await onAuthPressed(_userInputAuthService);
  }

  Future onForgetPasswordButtonPressed() async {
    SheetResponse? _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.Write,
        data: {
          'maxLength': 50,
          'keyboardType': TextInputType.emailAddress,
          'hintText': '이메일 입력',
        },
        title: '가입하신 이메일을 입력해주세요');
    if (_sheetResponse != null && _sheetResponse.confirmed) {
      String userEmail = _sheetResponse.data['input'].trim();
      if (userEmail == '' || !userEmail.contains('@')) {
        return _dialogService.showDialog(
          title: '오류',
          description: "유효하지 않은 이메일 형식입니다",
          buttonTitle: '확인',
          barrierDismissible: true,
        );
      } else {
        try {
          isBusy = true;
          notifyListeners();
          Map<String, dynamic> data = await _serverService.sendRequest(
              method: HttpMethod.post,
              resource: Resource.auth,
              endPath: '/passwordResetEmail',
              data: {"email": userEmail});
          isBusy = false;
          notifyListeners();
          return await _dialogService.showDialog(
            title: '비밀번호 초기화',
            description: data['message'],
            buttonTitle: '확인',
            barrierDismissible: true,
          );
        } on APIException catch (e) {
          isBusy = false;
          notifyListeners();
          return await _dialogService.showDialog(
            title: '오류',
            description: e.message,
            buttonTitle: '확인',
            barrierDismissible: true,
          );
        }
      }
    }
  }

  @override
  void onToggleButtonPressed() =>
      _navigationService.navigateTo(Routes.signupView);

  @override
  void setFormStatus() {
    isInputVaildToSubmit = false;
    if (emailValue != null &&
        !emailValue!.contains("@") &&
        emailValue!.length > 6) {
      setValidationMessage("이메일 형식이 올바르지 않습니다.");
    }
    if (passwordValue != null &&
        passwordValue!.isNotEmpty &&
        passwordValue!.length < 6) {
      setValidationMessage("비밀번호가 너무 짧습니다.");
    }
    if (emailValue!.isNotEmpty &&
        passwordValue!.isNotEmpty &&
        validationMessage == null) isInputVaildToSubmit = true;
  }
}
