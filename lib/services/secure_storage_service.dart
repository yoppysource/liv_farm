import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  //Read Data
  //ServerSerive에 넣어주세요 ^_^
  Future<String?> getValueFromStorage({required String key}) async {
    String? value = await _storage.read(key: key);
    return value;
  }

  Future<void> deleteValueFromStorage({required String key}) async {
    await _storage.delete(key: key);
  }

  Future<void> storeValueToStorage(
      {required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }
}
