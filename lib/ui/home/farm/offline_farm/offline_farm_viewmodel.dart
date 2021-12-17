import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/services/store_provider_service.dart';
import 'package:liv_farm/ui/home/farm/base_farm_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';

class OfflineFarmViewModel extends BaseFarmViewModel {
  PermissionStatus status;
  bool isScanning = false;
  final StoreProviderService _storeProviderService =
      locator<StoreProviderService>();
  OfflineFarmViewModel() {
    Future.microtask(() async {
      this.status = await Permission.camera.status;
    });
  }
  void getProductDetailPageFromQRCode(String inventoryId, AnimationController controller) {
    isScanning = false;
    Inventory inventory = _storeProviderService.store.inventories.firstWhere(
      (inventory) => inventory.id == inventoryId,
      orElse: () => null,
    );

    if (inventory == null) {
      isScanning = true;
    } else {
      controller.reverse();
      super.onProductTap(inventory);
    }
  }
}
