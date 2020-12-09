import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/repository/auth_page_repository/auth_page_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class KaKaoAuthRepository extends AuthPageRepository {
  Future<void> _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
    } catch (e) {
      print("error on issuing access token: $e");
    }
  }

  Future<Map<String, dynamic>> getInitialDataFromPackage() async {
    //TODO: 초기 화면으로 넘어갈때 카카오 뒤로가기가 생성되는 문제.
    try {
      final bool installed = await isKakaoTalkInstalled();
      final authCode = installed
          ? await AuthCodeClient.instance.requestWithTalk()
          : await AuthCodeClient.instance.request();
      print('kakao Install : ' + installed.toString());

      await _issueAccessToken(authCode);
      User user = await UserApi.instance.me();
      print(user.id);

      Map<String, dynamic> initialData = super.createInitialData(user.id.toString(), Platform_kakao);
      if (initialData[KEY_customer_snsId] != null) {
        return initialData;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> deleteAccountKakaoTalk() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove(KEY_access_token);

    try {
      var code = await UserApi.instance.unlink();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }
}
