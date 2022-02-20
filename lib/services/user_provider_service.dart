import 'package:flutter/foundation.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/server_service/client_service.dart';

class UserProviderService {
  MyUser? user;
  bool get isLogined => user == null ? false : true;
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();
  final CartProviderService _cartProviderService =
      locator<CartProviderService>();
  final ClientService _serverService = locator<ClientService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  void setUserFromJson(Map<String, dynamic> data) {
    user = MyUser.fromJson(data);
    _cartProviderService.syncCartFromInstance(user!.cart);
    _analyticsService.setUserProperties(userEmail: user!.email);
  }

  Future<void> syncUserFromServer() async {
    try {
      Map<String, dynamic> data = await _serverService.sendRequest(
          method: HttpMethod.get, resource: Resource.users, endPath: '/me');
      setUserFromJson(data);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> appendAddress(Address address) async {
    bool isDuplicated = false;
    for (var existedAddress in user!.addresses!) {
      if (existedAddress.address == address.address) {
        isDuplicated = true;
      }
    }
    if (!isDuplicated) {
      user!.addresses!.insert(0, address);
      await updateUserToServer();
    }
  }

  Future<void> updateUserToServer() async {
    try {
      Map<String, dynamic> data = await _serverService.sendRequest(
          method: HttpMethod.patch,
          resource: Resource.users,
          data: user!.toJson(),
          endPath: '/updateMe');

      setUserFromJson(data);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _secureStorageService.deleteValueFromStorage(key: KEY_JWT);
    user = null;
    _cartProviderService.resetCart();
  }
}
