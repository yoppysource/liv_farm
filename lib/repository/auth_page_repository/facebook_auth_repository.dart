import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/repository/auth_page_repository/auth_page_repository.dart';

class FacebookAuthRepository extends AuthPageRepository {
  Future<Map<String, dynamic>> getInitialDataFromPackage() async {
    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);

      if (result.status == FacebookLoginStatus.loggedIn) {
        Map<String, dynamic> initialData = Map();
        initialData[KEY_customer_snsId] = result.accessToken.userId.toString();
        initialData[KEY_customer_platform] = Platform_facebook;
        return initialData;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
