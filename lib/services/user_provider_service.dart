import 'package:flutter/foundation.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/server_service/server_service.dart';

class UserProviderService {
  MyUser user;
  bool get isLogined => this.user == null ? false : true;
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();
  final CartProviderService _cartProviderService =
      locator<CartProviderService>();
  final ServerService _serverService = locator<ServerService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  void setUserFromJson(Map<String, dynamic> data) {
    this.user = MyUser.fromJson(data);
    _cartProviderService.syncCartFromInstance(user.cart);
    _analyticsService.setUserProperties(userEmail: this.user.email);
  }

  Future<void> syncUserFromServer() async {
    try {
      Map<String, dynamic> data =
          await _serverService.getData(resource: Resource.users, path: '/me');
      setUserFromJson(data);
    } catch (e) {
      debugPrint(e.toString());
      throw e;
    }
  }

  Future<void> appendAddress(Address address) async {
    bool isDuplicated = false;
    this.user.addresses.forEach((Address existedAddress) {
      if (existedAddress.address == address.address) {
        isDuplicated = true;
      }
    });
    if (!isDuplicated) {
      this.user.addresses.insert(0, address);
      await updateUserToServer();
    }
  }

  Future<void> updateUserToServer() async {
    try {
      Map<String, dynamic> data =
          await _serverService.patchData<Map<String, dynamic>>(
              resource: Resource.users, data: user.toJson(), path: '/updateMe');

      setUserFromJson(data);
    } catch (e) {
      debugPrint(e.toString());
      throw e;
    }
  }

  Future<void> logout() async {
    await _secureStorageService.deleteValueFromStorage(key: KEY_JWT);
    this.user = null;
    _cartProviderService.resetCart();
  }
}
