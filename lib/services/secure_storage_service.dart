import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:liv_farm/secret.dart';

class SecureStorageService {
  final _storage = FlutterSecureStorage();
  final key = KEY_JWT;

  //Read Data
  //ServerSerive에 넣어주세요 ^_^
  Future<String> getTokenFromStorage() async {
    String jwt = await _storage.read(key: key);
    return jwt ?? '';
  }

  Future<void> deleteTokenFromStorage() async {
    await _storage.delete(key: key);
  }

  Future<void> storeTokenToStorage({String token}) async {
    await _storage.write(key: key, value: token);
    String jwt = await _storage.read(key: key);
    print(jwt);
  }
}
