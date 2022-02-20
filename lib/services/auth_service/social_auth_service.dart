import 'package:liv_farm/services/auth_service/auth_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';

class KakaoAuthService extends AuthService {
  @override
  Future<Map<String, dynamic>> createCredential() async {
    final bool installed = await isKakaoTalkInstalled();
    final authCode = installed
        ? await AuthCodeClient.instance.requestWithTalk()
        : await AuthCodeClient.instance.request();
    OAuthToken token = await AuthApi.instance.issueAccessToken(authCode);
    TokenManagerProvider.instance.manager.setToken(token);
    User user = await UserApi.instance.me();

    return generateMapFromSocialAuth(
        snsId: user.id.toString(),
        email: user.kakaoAccount?.email,
        platform: "kakao");
  }
}

class AppleAuthService extends AuthService {
  @override
  Future<Map<String, dynamic>> createCredential() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
      ],
    );

    return generateMapFromSocialAuth(
        snsId: credential.userIdentifier.toString(),
        email: credential.email,
        platform: "apple");
  }
}

class GoogleAuthService extends AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
  ]);
  @override
  Future<Map<String, dynamic>> createCredential() async {
    // final GoogleSignInAccount googleUser =
    //     await GoogleSignIn(scopes: ['email']).signIn();
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception();

    String uid = googleUser.id;
    String? email = googleUser.email;
    return generateMapFromSocialAuth(
        snsId: uid, email: email, platform: "google");
  }
}
