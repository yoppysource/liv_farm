import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/services/in_offine_store_service.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:stacked_services/stacked_services.dart';

class DynamicLinkService {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final InOffineStoreService _inOffineStoreService =
      locator<InOffineStoreService>();

  Future handleDynamicLinks() async {
    // Firstly, when app start with deep link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) await _handleDeepLink(data);

    // Secondly, when app was on background and triggered with deep link
    FirebaseDynamicLinks.instance.onLink(
        // Register call back
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      await _handleDeepLink(dynamicLink);
      _navigationService.replaceWith(Routes.landingView);
    }, onError: (OnLinkErrorException e) async {
      debugPrint('${e.message}');
      await _dialogService.showDialog(
        title: "오류",
        description: "연동 중 오류가 발생했습니다",
      );
    });
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    try {
    final Uri deepLink = data?.link;
    if (data == null)
      return; // If there is no deep link provided, the data is null.
    var isInStore = deepLink.pathSegments.contains('in-store');
    if (isInStore)
      await _inOffineStoreService.switchToOffineMode(deepLink.queryParameters['storeId']);  
    } catch (e) {
      debugPrint('${e.message}');
      await _dialogService.showDialog(
        title: "오류",
        description: "연동 중 오류가 발생했습니다",
      );
    }
  }
}
