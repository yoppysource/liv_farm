import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liv_farm/repository/auth_page_repository/auth_page_repository.dart';

import '../../constant.dart';

class AppleAuthRepository extends AuthPageRepository {
  Future<Map<String, dynamic>> getInitialDataFromPackage() async {
    try {
      AuthorizationRequest authorizationRequest = AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName]);
      AuthorizationResult authorizationResult = await AppleSignIn.performRequests([authorizationRequest]);
      AppleIdCredential appleCredential = authorizationResult.credential;
      OAuthProvider provider = OAuthProvider("apple.com");
      AuthCredential credential = provider.credential( idToken: String.fromCharCodes(appleCredential.identityToken), accessToken: String.fromCharCodes(appleCredential.authorizationCode), );
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential _userCredential = await auth.signInWithCredential(credential);
      if(_userCredential !=null){
        Map<String, dynamic> initialData = Map();
        initialData[KEY_customer_snsId] = _userCredential.user.uid.toString();
        initialData[KEY_customer_platform] = Platform_apple;
        return initialData;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
