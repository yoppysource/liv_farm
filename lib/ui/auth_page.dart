import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/login_button.dart';
import 'package:liv_farm/ui/web_view_page/policy_page.dart';
import 'package:liv_farm/viewmodel/auth_page_view_model.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  Future<void> onPressed(Future<void> onPress, BuildContext context, AuthPageViewmodel model) async {
    await onPress;
    if(model.isSuccess) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //TODO: 왜 false를 두면 안되고 true를 둬야할까. notifiyListener는 콜되는데 rebuild는 되지 않는다.
    log.builderLog(className: 'AuthPage');
    AuthPageViewmodel _model =
        Provider.of<AuthPageViewmodel>(context, listen: true);

    return Scaffold(
      appBar: MyAppBar(),
      body: _model.isWorking
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Image.asset(
                    kLogo,
                    color: Color(kMainColor),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                LoginButton(
                  assetName: 'assets/images/kakao_icon.png',
                  text: 'Kakao로 로그인',
                  onPressed: () async =>
                      await onPressed(_model.onPressedKakao(context), context, _model),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                LoginButton(
                  assetName: 'assets/images/google_icon.png',
                  text: 'Google로 로그인',
                  onPressed: () async =>
                      await onPressed(_model.onPressedGoogle(context), context, _model),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                LoginButton(
                  assetName: 'assets/images/facebook_icon.png',
                  text: 'Facebook으로 로그인',
                  onPressed: () async => await onPressed(
                      _model.onPressedFacebook(context), context, _model),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _model?.isApple ?? false
                    ? LoginButton(
                        assetName: 'assets/images/apple_icon.png',
                        text: 'Apple로 로그인',
                        onPressed: () async => await onPressed(
                            _model.onPressedApple(context), context, _model),
                      )
                    : Container(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '최초 로그인 시 ',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PolicyPage()));
                      },
                      child: Stack(
                        children: <Widget>[
                          Text(
                            '개인정보보호약관',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              height: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      ' 에 동의한 것으로 간주합니다.',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
