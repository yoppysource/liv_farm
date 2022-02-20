import 'package:liv_farm/services/auth_service/auth_service.dart';

class UserInputAuthService extends AuthService {
  @override
  String get path => isSignup ? '/signup' : '/login';

  final bool isSignup;
  String? email;
  String? password;
  String? passwordConfirm;

  UserInputAuthService({required this.isSignup});

  @override
  Map<String, String?> createCredential() {
    Map<String, String?> data = {};
    data['email'] = email;
    data['password'] = password;
    if (isSignup) data['passwordConfirm'] = passwordConfirm;

    return data;
  }
}
