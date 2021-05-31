import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';

abstract class AuthService {
  String get path;
  getInitialData();

  ServerService _serverService =
      ServerService(apiPath: APIPath(resource: Resource.users));
  SecureStorageService _storageService = locator<SecureStorageService>();
  UserProviderService _userService = locator<UserProviderService>();

  Map<String, String> createInitialData(
      {String snsId, String email, String platform}) {
    return {
      "snsId": snsId,
      "email": email,
      "platform": platform,
    };
  }

  Future<void> saveTokenToLocalStorage(String token) async =>
      await _storageService.storeTokenToStorage(token: token);

  Future<void> runAuth() async {
    Map<String, dynamic> data = await getInitialData();
    Map<String, dynamic> body =
        await _serverService.postData(data: data, path: path, isForLogin: true);
    await saveTokenToLocalStorage(body["token"]);
    ServerService.accessToken = body["token"];
    debugPrint(ServerService.accessToken);

    _userService.setUserFromJson(body["data"]["data"]);
  }
}
