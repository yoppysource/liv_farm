import 'package:liv_farm/services/auth_service/auth_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';

class KakaoAuthService extends AuthService {
  @override
  final path = '/socialLogin';
  @override
  Future<Map<String, dynamic>> getInitialData() async {
    final bool installed = await isKakaoTalkInstalled();
    final authCode = installed
        ? await AuthCodeClient.instance.requestWithTalk()
        : await AuthCodeClient.instance.request();
    var token = await AuthApi.instance.issueAccessToken(authCode);
    AccessTokenStore.instance.toStore(token);
    print(token);
    User user = await UserApi.instance.me();

    return createInitialData(
        snsId: user.id.toString(),
        email: user.kakaoAccount.email,
        platform: "kakao");
  }
}

class FacebookAuthService extends AuthService {
  @override
  final path = '/socialLogin';

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    final FacebookLogin plugin = FacebookLogin(debug: false);
    final result = await plugin.logIn(permissions: [
      FacebookPermission.email,
    ]);
    final email = await plugin.getUserEmail();
    if (result.status == FacebookLoginStatus.success) {
      return createInitialData(
          snsId: result.accessToken.userId.toString(),
          email: email,
          platform: "facebook");
    } else {
      print(result);
      throw Exception();
    }
  }
}

class AppleAuthService extends AuthService {
  @override
  final path = '/socialLogin';
  @override
  Future<Map<String, dynamic>> getInitialData() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
      ],
    );

    return createInitialData(
        snsId: credential.userIdentifier.toString(),
        email: credential.email,
        platform: "apple");
  }
}

class GoogleAuthService extends AuthService {
  @override
  final path = '/socialLogin';
  @override
  Future<Map<String, dynamic>> getInitialData() async {
    final GoogleSignInAccount googleUser =
        await GoogleSignIn(scopes: ['email']).signIn();

    String uid = googleUser.id;
    String email = googleUser.email;
    return createInitialData(snsId: uid, email: email, platform: "google");
  }
}
