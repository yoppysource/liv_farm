import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/repository/auth_page_repository/auth_page_repository.dart';

class FacebookAuthRepository extends AuthPageRepository {
  Future<Map<String, dynamic>> getInitialDataFromPackage() async {
    try {
      final FacebookLogin plugin = FacebookLogin(debug: true);
      //TODO: debug바꾸기
      final result = await plugin.logIn(permissions: [
      FacebookPermission.email,
      ]);

      if (result.status == FacebookLoginStatus.success) {
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
