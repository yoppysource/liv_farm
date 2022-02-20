import 'package:flutter/material.dart';
import 'package:liv_farm/ui/auth/login/login_view.form.dart';
import 'package:liv_farm/ui/auth/login/login_viewmodel.dart';
import 'package:liv_farm/ui/auth/layout/auth_layout.dart';
import 'package:liv_farm/ui/shared/my_text_field.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(fields: [
  FormTextField(name: 'email'),
  FormTextField(name: 'password', isPassword: true),
])
class LoginView extends StatelessWidget with $LoginView {
  LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      onModelReady: (model) => listenToFormUpdated(model),
      viewModelBuilder: () => LoginViewModel(),
      builder: (
        context,
        model,
        child,
      ) {
        return Scaffold(
            body: AuthLayout(
          busy: model.isBusy,
          title: '로그인',
          toggleQuestionText: '아직 계정이 없으신가요?',
          onForgetPasswordButtonPressed: model.onForgetPasswordButtonPressed,
          mainButtonTitle: "로그인",
          form: Column(
            children: [
              verticalSpaceRegular,
              MyTextField(
                hintText: '이메일',
                focusNode: emailFocusNode,
                controller: emailController,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(passwordFocusNode),
              ),
              verticalSpaceRegular,
              MyTextField(
                hintText: '비밀번호',
                focusNode: passwordFocusNode,
                controller: passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  if (model.isInputVaildToSubmit) {
                    FocusScope.of(context).unfocus();
                    model.onMainButtonPressed();
                  }
                },
              )
            ],
          ),
          isVaildToSubmit: model.isInputVaildToSubmit,
          validationMessage: model.validationMessage,
          onMainButtonPressed: model.onMainButtonPressed,
          onBackButtonPressed: model.onBackButtonPressed,
          onToggleButtonPressed: model.onToggleButtonPressed,
          // onFacebookPressed: model.onFacebookPressed,
          onKakaoPressed: model.onKakaoPressed,
          onApplePressed: model.onApplePressed,
          onGooglePressed: model.onGooglePressed,
        ));
      },
    );
  }
}
