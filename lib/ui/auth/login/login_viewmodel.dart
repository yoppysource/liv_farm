import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/services/auth_service/user_input_auth_service.dart';
import 'package:liv_farm/ui/auth/auth_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import 'login_view.form.dart';

class LoginViewModel extends AuthViewModel {
  final _navigationService = locator<NavigationService>();
  final UserInputAuthService _userInputAuthService =
      UserInputAuthService(isSignup: false);

  @override
  Future<void> onMainButtonPressed() async {
    _userInputAuthService.email = emailValue?.trim();
    _userInputAuthService.password = passwordValue?.trim();
    await onAuthPressed(_userInputAuthService);
  }

  @override
  void onToggleButtonPressed() =>
      _navigationService.navigateTo(Routes.signupView);

  @override
  void setFormStatus() {
    isInputVaildToSubmit = false;
    if (!emailValue.contains("@") && emailValue.length > 6)
      setValidationMessage("이메일 형식이 올바르지 않습니다.");
    if (passwordValue.isNotEmpty && passwordValue.length < 8)
      setValidationMessage("비밀번호가 너무 짧습니다.");
    if (emailValue.isNotEmpty &&
        passwordValue.isNotEmpty &&
        validationMessage == null) isInputVaildToSubmit = true;
  }
}
