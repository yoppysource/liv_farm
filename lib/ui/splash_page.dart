import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/repository/landing_page_repository.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/alert_dialog.dart';
import 'package:store_redirect/store_redirect.dart';

class SplashPage extends StatelessWidget {
  final Version version;

  const SplashPage({Key key, this.version}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(version == Version.needToBeUpdated || version == Version.fail)
    Future.delayed(Duration.zero, () {
      if (version == Version.fail) {
        PlatformAlertDialog(title: '오류',
          widget: Text('오류가 발생했습니다.\n잠시 후에 다시 시도해 주세요.'),
          defaultActionText: '확인',)
            .show(context).then((value) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        });
      }
      if (version == Version.needToBeUpdated) {
        PlatformAlertDialog(title: '알림',
          widget: Text('사용하시는 버전이 너무 낮습니다.\n안전한 쇼핑을 위해 앱을 업데이트 해주세요.'),
          defaultActionText: '확인',)
            .show(context).then((value) async{
          await StoreRedirect.redirect(
              androidAppId: "com.future_connect.liv_farm",
              iOSAppId: "1550565167");
        });
      }
    });
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.7,
          child: Image.asset(kLogo,
            color: Color(kMainColor),
          ),
        ),
      ),
    );
  }
}
