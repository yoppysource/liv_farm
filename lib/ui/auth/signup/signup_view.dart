import 'package:flutter/material.dart';
import 'package:liv_farm/ui/auth/signup/signup_view.form.dart';
import 'package:liv_farm/ui/auth/signup/signup_viewmodel.dart';
import 'package:liv_farm/ui/auth/layout/auth_layout.dart';
import 'package:liv_farm/ui/shared/my_text_field.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(fields: [
  FormTextField(name: 'email'),
  FormTextField(name: 'password', isPassword: true),
  FormTextField(name: 'passwordConfirm', isPassword: true),
])
class SignupView extends StatelessWidget with $SignupView {
  SignupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.reactive(
      onModelReady: (model) => listenToFormUpdated(model),
      viewModelBuilder: () => SignupViewModel(),
      builder: (
        BuildContext context,
        SignupViewModel model,
        child,
      ) {
        return Scaffold(
            body: AuthLayout(
          busy: model.isBusy,
          title: '회원가입',
          mainButtonTitle: "회원가입",
          toggleQuestionText: '이미 계정이 있으신가요?',
          validationMessage: model.validationMessage ?? '',
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
                onEditingComplete: () => FocusScope.of(context)
                    .requestFocus(passwordConfirmFocusNode),
              ),
              verticalSpaceRegular,
              MyTextField(
                hintText: '비밀번호 확인',
                focusNode: passwordConfirmFocusNode,
                controller: passwordConfirmController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  if (model.isInputVaildToSubmit) {
                    FocusScope.of(context).unfocus();
                    model.onMainButtonPressed();
                  }
                },
              ),
              verticalSpaceRegular,
            ],
          ),
          isVaildToSubmit: model.isInputVaildToSubmit,
          onMainButtonPressed: model.onMainButtonPressed,
          onToggleButtonPressed: model.onBackButtonPressed,
          onBackButtonPressed: model.onBackButtonPressed,
          // onFacebookPressed: model.onFacebookPressed,
          onKakaoPressed: model.onKakaoPressed,
          onApplePressed: model.onApplePressed,
          onGooglePressed: model.onGooglePressed,
        ));
      },
    );
  }
}
