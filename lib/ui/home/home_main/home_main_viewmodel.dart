import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/store.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/store_provider_service.dart';
import 'package:liv_farm/ui/home/farm/online_farm/online_farm_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeMainViewModel extends BaseViewModel {
  final StoreProviderService _storeProviderService =
      locator<StoreProviderService>();
  final DialogService _dialogService = locator<DialogService>();
  final CartProviderService _cartProviderService =
      locator<CartProviderService>();
  final OnlineFarmViewModel _onlineFarmViewModel =
      locator<OnlineFarmViewModel>();
  @override
  bool isBusy = false;

  Store get store => _storeProviderService.store!;
  List<Inventory> get recommendedInventoryList =>
      _onlineFarmViewModel.recommendedInventoryList;
  Function get onTapForRecommended => _onlineFarmViewModel.onProductTap;
  bool get showBubbleInformation {
    bool closerStore = false;
    if (_storeProviderService.store!.distance != null) {
      double distance = _storeProviderService.store!.distance!;
      for (Store store in _storeProviderService.storeList!) {
        if (distance > store.distance!) {
          closerStore = true;
        }
      }
    }
    return closerStore;
  }

  Future<void> onPressForChangingStore() async {
    String storeId = _storeProviderService.store!.id;
    isBusy = true;
    notifyListeners();
    await _storeProviderService.selectShopByBottomSheet();

    if (storeId != _storeProviderService.store!.id) {
      await _cartProviderService
          .updateCartWhenStoreSet(_storeProviderService.store!.id);
      await _onlineFarmViewModel.getInventories();
    }
    isBusy = false;
    notifyListeners();
  }

  void onTapForInformation() async {
    _dialogService.showDialog(
        title: '상점정보',
        description:
            '주소${store.address}\n운영시간: ${store.openHourStr} ~ ${store.closeHourStr}\n휴일: 일요일',
        barrierDismissible: true,
        buttonTitle: '확인');
  }
}
