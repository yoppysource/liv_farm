
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/repository/auth_page_repository/auth_page_repository.dart';

class FacebookAuthRepository extends AuthPageRepository {
  Future<Map<String, dynamic>> getInitialDataFromPackage() async {
    try{  final AccessToken result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.token);
    UserCredential _credential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    Map<String, dynamic> initialData = Map();
          initialData[KEY_customer_snsId] = _credential.user.uid;
          initialData[KEY_customer_email] = _credential.user.email;
          initialData[KEY_customer_platform] = Platform_facebook;
          return initialData;

    }catch(e) {
      return null;
    }

    // Once signed in, return the UserCredential
    // try {
    //   final FacebookLogin plugin = FacebookLogin(debug: false);
    //   final result = await plugin.logIn(permissions: [
    //   FacebookPermission.email,
    //   ]);
    //   final email = await plugin.getUserEmail();
    //
    //   if (result.status == FacebookLoginStatus.success) {
    //     Map<String, dynamic> initialData = Map();
    //     initialData[KEY_customer_snsId] = result.accessToken.userId.toString();
    //     initialData[KEY_customer_email] = email;
    //     initialData[KEY_customer_platform] = Platform_facebook;
    //     return initialData;
    //   } else {
    //     return null;
    //   }
    // } catch (e) {
    //   return null;
    // }
  }
}
