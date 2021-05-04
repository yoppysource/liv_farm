import 'package:flutter/widgets.dart';
import 'package:liv_farm/services/auth_service/auth_service.dart';

class UserInputAuthService extends AuthService {
  final bool isSignup;

  String email;
  String password;
  String passwordConfirm;

  UserInputAuthService({@required this.isSignup});

  @override
  Map<String, String> getInitialData() {
    Map<String, String> data = new Map();
    data['email'] = email;
    data['password'] = password;
    if (isSignup) data['passwordConfirm'] = passwordConfirm;

    return data;
  }

  @override
  String get path => isSignup ? '/signup' : '/login';
}
