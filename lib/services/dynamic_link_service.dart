import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:stacked_services/stacked_services.dart';

class DynamicLinkService {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  // final InOffineStoreService _inOffineStoreService =
  //     locator<InOffineStoreService>();
  final FirebaseDynamicLinks _instance = FirebaseDynamicLinks.instance;
  final SecureStorageService _storageService = locator<SecureStorageService>();

  Future handleDynamicLinks() async {
    final PendingDynamicLinkData? data = await _instance.getInitialLink();
    if (data != null) await _handleDeepLink(data);

    //this call back triggered when the app is on background
    _instance.onLink.listen((dynamicLinkData) async {
      await _handleDeepLink(dynamicLinkData);
      _navigationService.replaceWith(Routes.landingView);
    }).onError((error) async {
      debugPrint('${error.message}');
      await _dialogService.showDialog(
        title: "오류",
        description: "연동 중 오류가 발생했습니다",
      );
    });
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    try {
      final Uri deepLink = data.link;
      var isShopExistInUrl = deepLink.pathSegments.contains('shop');
      if (isShopExistInUrl) {
        String? storeId = deepLink.queryParameters['id'];
        if (storeId != null) {
          _storageService.storeValueToStorage(key: KEY_STORE, value: storeId);
        }
        // await _inOffineStoreService.switchToOffineMode();
      }
    } catch (e) {
      debugPrint('$e');
      await _dialogService.showDialog(
        title: "오류",
        description: "연동 중 오류가 발생했습니다",
      );
    }
  }
}
