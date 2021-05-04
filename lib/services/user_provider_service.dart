import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';

class UserProviderService {
  MyUser user;
  bool get isLogined => this.user == null ? false : true;
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();
  final ServerService _serverService =
      ServerService(apiPath: APIPath(resource: Resource.users));

  void setUserFromJson(Map<String, dynamic> data) {
    print(data);
    this.user = MyUser.fromJson(data);
    print(this.user.email);
  }

  Future<void> syncUserFromServer() async {
    Map<String, dynamic> data = await _serverService.getData(path: '/me');
    setUserFromJson(data['data']);
  }

  Future<void> updateUserToServer() async {
    try {
      await _serverService.patchData(data: user.toJson(), path: '/updateMe');
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> logout() async {
    await _secureStorageService.deleteTokenFromStorage();
    this.user = null;
  }
}