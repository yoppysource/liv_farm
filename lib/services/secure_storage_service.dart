import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = FlutterSecureStorage();

  //Read Data
  //ServerSerive에 넣어주세요 ^_^
  Future<String> getValueFromStorage({String key}) async {
    String jwt = await _storage.read(key: key);
    return jwt ?? '';
  }

  Future<void> deleteValueFromStorage({String key}) async {
    await _storage.delete(key: key);
  }

  Future<void> storeValueToStorage({String key, String value}) async {
    await _storage.write(key: key, value: value);
  }
}
