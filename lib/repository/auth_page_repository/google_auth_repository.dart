import 'package:firebase_auth/firebase_auth.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/repository/auth_page_repository/auth_page_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthRepository extends AuthPageRepository {
  Future<Map<String, dynamic>> getInitialDataFromPackage() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential _credential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      String uid = _credential.user.uid;

      Map<String, dynamic> initialData =
          super.createInitialData(uid, Platform_google);

      return initialData;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
