import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';

abstract class AuthService {
  String get path => '/socialLogin';
  createCredential();

  final ClientService _serverService = locator<ClientService>();
  final SecureStorageService _storageService = locator<SecureStorageService>();
  final UserProviderService _userProviderService =
      locator<UserProviderService>();

  Map<String, String> generateMapFromSocialAuth(
      {required String snsId, String? email, required String platform}) {
    final Map<String, String> mapFromSocialAuth = {};
    mapFromSocialAuth["snsId"] = snsId;
    mapFromSocialAuth["platform"] = platform;
    if (email != null) mapFromSocialAuth["email"] = email;
    return mapFromSocialAuth;
  }

  Future<void> runAuth() async {
    Map<String, dynamic> data = await createCredential();
    Map<String, dynamic> body = await _serverService.sendRequest(
        method: HttpMethod.post,
        resource: Resource.auth,
        data: data,
        endPath: path,
        getAllData: true);
    await _storageService.storeValueToStorage(
        key: KEY_JWT, value: body["token"]);
    ClientService.accessToken = body["token"];
    _userProviderService.setUserFromJson(body["data"]["data"]);
  }
}
