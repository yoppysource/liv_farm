import 'dart:async';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/option_group.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/server_service/api_exception.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/farm/online_farm/online_farm_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductDetailViewModel extends FutureViewModel {
  ProductDetailViewModel({required this.inventory});
  Inventory inventory;
  Product get product => inventory.product;
  List<Review>? reviews = [];
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final DialogService _dialogService = locator<DialogService>();
  final ClientService _clientService = locator<ClientService>();
  final UserProviderService _userProviderService =
      locator<UserProviderService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final CartProviderService _cartProviderService =
      locator<CartProviderService>();
  final OnlineFarmViewModel _onlineFarmViewModel =
      locator<OnlineFarmViewModel>();

  @override
  Future<void> futureToRun() async {
    try {
      Map<String, dynamic> data =
          await _clientService.sendRequest<Map<String, dynamic>>(
              method: HttpMethod.get,
              resource: Resource.inventories,
              endPath: '/${inventory.id}');
      inventory = Inventory.fromJson(data);
      List reviewData = await _clientService.sendRequest<List>(
          method: HttpMethod.get,
          resource: Resource.products,
          endPath: '/${inventory.product.id}/reviews');
      reviews =
          reviewData.map((e) => Review.fromJson(e)).toList().reversed.toList();

      inventory = Inventory.fromJson(data);
      // update inventory info whenever user tap product
      _onlineFarmViewModel.updateInventory(inventory);
    } catch (e) {
      ToastMessageService.showToast(message: "상품정보를 가져오는데 실패하였습니다.");
    }
  }

  void onBackPressed() {
    _navigationService.back();
  }

  Future<void> onTapForReport(Review review) async {
    try {
      await _clientService.sendRequest(
          method: HttpMethod.patch,
          resource: Resource.products,
          endPath: '/${product.id}/reviews/${review.id}/report',
          data: {});
      ToastMessageService.showToast(message: '신고가 정상적으로 접수되었습니다.');
    } on APIException catch (e) {
      ToastMessageService.showToast(message: e.message);
    } catch (e) {
      ToastMessageService.showToast(message: "오류가 발생했습니다");
    }
  }

  Future<void> onTapAddToCart() async {
    if (!_userProviderService.isLogined) {
      DialogResponse? _dialogResponse =
          await _dialogService.showConfirmationDialog(
        title: '로그인이 필요합니다',
        description: '로그인 또는 회원가입을 하시겠습니까?',
        cancelTitle: '취소',
        confirmationTitle: '로그인하기',
        barrierDismissible: true,
      );
      if (_dialogResponse != null && _dialogResponse.confirmed) {
        _navigationService.navigateTo(Routes.loginView);
      }
      return;
    }
    Item item = Item(
      inventory: inventory,
      options: [],
      quantity: 1,
    );

    if (inventory.optionGroups.isNotEmpty) {
      SheetResponse? _sheetResponse =
          await _bottomSheetService.showCustomSheet<dynamic, List<OptionGroup>>(
              variant: BottomSheetType.optionGroups,
              data: inventory.optionGroups);
      if (_sheetResponse == null || _sheetResponse.confirmed == false) {
        return;
      } else {
        item.options.addAll(_sheetResponse.data);
      }
    }

    SheetResponse? _sheetResponse =
        await _bottomSheetService.showCustomSheet<dynamic, Item>(
            variant: BottomSheetType.AddToCart, data: item);
    if (_sheetResponse == null || _sheetResponse.confirmed == false) {
      return;
    } else {
      item.quantity = _sheetResponse.data;
    }
    await _cartProviderService.addToCart(item);
  }
}
