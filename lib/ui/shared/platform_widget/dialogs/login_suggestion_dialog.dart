import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/alert_dialog.dart';

class LoginSuggestionDialog extends PlatformAlertDialog {
  LoginSuggestionDialog(): super(title: '알림',widget: Text('로그인이 필요한 페이지입니다.'), defaultActionText: '로그인 하기',cancelActionText: '취소');
}
