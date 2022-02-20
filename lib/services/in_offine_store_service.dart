import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/secure_storage_service.dart';

class InOffineStoreService {
  bool _isOffineMode = false;
  String? storeId;
  bool get isOffineMode => _isOffineMode;
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();

  InOffineStoreService() {
    _isOffineMode = false;
  }

  Future<void> switchToOffineMode(String? storeId) async {
    try {
      if (storeId == null) return;
      await _secureStorageService.storeValueToStorage(
          key: KEY_STORE, value: storeId);
      _isOffineMode = true;
      this.storeId = storeId;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> backToOnlineMode() async {
    try {
      await _secureStorageService.deleteValueFromStorage(key: KEY_STORE);
      _isOffineMode = false;
      storeId = null;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
