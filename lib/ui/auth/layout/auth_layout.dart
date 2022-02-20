import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/my_farm/policy_page/policy_page.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final String toggleQuestionText;
  final Widget form;
  final String mainButtonTitle;
  final bool showTermsText;
  final Function onMainButtonPressed;
  final Function onToggleButtonPressed;
  final Function? onForgetPasswordButtonPressed;
  final Function onBackButtonPressed;
  final Function onGooglePressed;
  final Function onApplePressed;
  final Function onKakaoPressed;
  final String? validationMessage;
  final bool busy;
  final bool isVaildToSubmit;

  const AuthLayout({
    required this.title,
    required this.toggleQuestionText,
    required this.form,
    required this.onMainButtonPressed,
    this.validationMessage,
    required this.onToggleButtonPressed,
    this.onForgetPasswordButtonPressed,
    required this.onBackButtonPressed,
    required this.onGooglePressed,
    required this.onApplePressed,
    required this.onKakaoPressed,
    this.mainButtonTitle = 'CONTINUE',
    this.showTermsText = false,
    this.busy = false,
    this.isVaildToSubmit = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: busy,
      opacity: 0.8,
      color: Colors.black87,
      child: ListView(
        children: [
          Padding(
            padding: horizontalPaddingToScaffold,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black.withOpacity(0.75),
                    size: 32,
                  ),
                  onPressed: () => onBackButtonPressed(),
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                verticalSpaceMedium,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                form,

                if (onForgetPasswordButtonPressed != null)
                  Column(
                    children: [
                      verticalSpaceMedium,
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => onForgetPasswordButtonPressed!(),
                          child: Text(
                            '비밀번호를 잊어버리셨습니까?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                validationMessage != null
                    ? Column(
                        children: [
                          verticalSpaceSmall,
                          Text(validationMessage!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.red)),
                          verticalSpaceSmall,
                        ],
                      )
                    : verticalSpaceMedium,
                AuthButton(
                  needBorder: false,
                  color: kMainColor,
                  onPressed: isVaildToSubmit
                      ? () {
                          FocusScope.of(context).unfocus();
                          onMainButtonPressed();
                        }
                      : null,
                  child: Text(
                    mainButtonTitle,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ),
                verticalSpaceMedium,
                GestureDetector(
                  onTap: () => onToggleButtonPressed(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        toggleQuestionText,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.black54),
                      ),
                      horizontalSpaceSmall,
                      Text(
                        '${title == '로그인' ? '회원가입' : '로그인'}하기',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
                if (showTermsText) const Text('이용정보 보호 약관'),
                verticalSpaceMedium,
                // Container(
                //     height: MediaQuery.of(context).size.height * 0.4,
                //     child: Center(
                //         child: Image.asset('assets/images/livLogo.png'))),

                AuthButton(
                  needBorder: true,
                  color: Colors.white,
                  onPressed: onGooglePressed,
                  child: const SocialAuthContent(
                    assetPath: "assets/images/google_icon.png",
                    text: "Google로 계속하기",
                  ),
                ),
                verticalSpaceMedium,
                AuthButton(
                  needBorder: false,
                  color: const Color(0xfffee500),
                  onPressed: onKakaoPressed,
                  child: const SocialAuthContent(
                    assetPath: "assets/images/kakao_icon.png",
                    text: "Kakao로 계속하기",
                  ),
                ),
                // verticalSpaceMedium,
                // AuthButton(
                //   needBorder: false,
                //   color: Color(0xff3b5998),
                //   onPressed: onFacebookPressed,
                //   child: SocialAuthContent(
                //     assetPath: "assets/images/facebook_icon.png",
                //     text: "Facebook으로 계속하기",
                //     textColor: Colors.white,
                //   ),
                // ),
                verticalSpaceMedium,
                if (Platform.isIOS)
                  AuthButton(
                    needBorder: true,
                    color: Colors.black,
                    onPressed: onApplePressed,
                    child: const SocialAuthContent(
                      assetPath: "assets/images/apple_icon.png",
                      text: "Apple로 계속하기",
                      textColor: Colors.white,
                      assetColor: Colors.white,
                    ),
                  ),
                verticalSpaceMedium,
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PolicyPage()));
                    },
                    child: Text('최초 로그인 시 개인보호정책에 동의한 것으로 간주됩니다',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            textBaseline: TextBaseline.alphabetic)),
                  ),
                ),
                verticalSpaceMedium,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SocialAuthContent extends StatelessWidget {
  final String assetPath;
  final String text;
  final Color textColor;
  final Color? assetColor;

  const SocialAuthContent(
      {Key? key,
      required this.assetPath,
      required this.text,
      this.textColor = Colors.black,
      this.assetColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.height * 0.03,
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                color: assetColor,
              )),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
            width: MediaQuery.of(context).size.height * 0.03,
            child: Opacity(
              opacity: 0.0,
              child: Image.asset(
                assetPath,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton(
      {Key? key,
      this.onPressed,
      required this.child,
      required this.color,
      required this.needBorder})
      : super(key: key);

  final Function? onPressed;
  final Widget child;
  final Color color;
  final bool needBorder;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed == null) {
          return;
        } else {
          onPressed!();
        }
      },
      child: Container(
        width: double.infinity,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: needBorder
                ? Border.all(width: 0.5, color: Colors.black54)
                : null,
            color: onPressed == null ? Colors.grey : color,
            borderRadius: BorderRadius.circular(10)),
        child: child,
      ),
    );
  }
}
