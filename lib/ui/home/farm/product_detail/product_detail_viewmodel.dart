import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/farm/farm_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductDetailViewModel extends FutureViewModel {
  Inventory inventory;
  Product product;
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  FarmViewModel _farmViewModel = locator<FarmViewModel>();
  DialogService _dialogService = locator<DialogService>();
  ServerService _serverService = locator<ServerService>();
  UserProviderService _userProviderService = locator<UserProviderService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  NavigationService _navigationService = locator<NavigationService>();
  CartProviderService _cartProviderService = locator<CartProviderService>();

  ProductDetailViewModel({@required this.inventory});

  @override
  Future<void> futureToRun() async {
    try {
      Map<String, dynamic> data =
          await _serverService.getData<Map<String, dynamic>>(
              resource: Resource.products,
              path: '/${this.inventory.product.id}');
      this.product = Product.fromJson(data);
    } catch (e) {
      print(e);
      ToastMessageService.showToast(message: "상품정보를 가져오는데 실패하였습니다.");
    }
  }

  void onBackPressed() {
    _navigationService.back();
  }

  Future<void> onTapForReport(Review review) async {
    try {
      dynamic data = await _serverService.patchData<Map<String, dynamic>>(
        resource: Resource.products,
        path: '/${product.id}/reviews/${review.id}/report',
        data: {},
      );
      print(data);
      ToastMessageService.showToast(message: '신고가 정상적으로 접수되었습니다.');
    } on APIException catch (e) {
      ToastMessageService.showToast(message: e.message);
    } catch (e) {
      print(e.toString());
      ToastMessageService.showToast(message: "오류가 발생했습니다");
    }
  }

  Future<void> addToCart({String inventoryId, int quantity}) async {
    try {
      Map<String, dynamic> data =
          await _serverService.postData<Map<String, dynamic>>(
              resource: Resource.carts,
              data: {'inventory': inventoryId, 'quantity': quantity},
              path: '/my/item');
      _cartProviderService.syncCartFromJson(data);

      ToastMessageService.showToast(message: '장바구니에 담았습니다');
    } catch (e) {
      await _dialogService.showDialog(
          title: '오류',
          description: e.message?.toString() ?? "오류가 발생했습니다.",
          barrierDismissible: true,
          buttonTitle: '확인');
    }
    notifyListeners();
  }

  Future<void> onCartTap() async {
    if (!_userProviderService.isLogined) {
      DialogResponse pressYes = await _dialogService.showConfirmationDialog(
        title: '로그인이 필요합니다',
        description: '로그인 또는 회원가입을 하시겠습니까?',
        cancelTitle: '취소',
        confirmationTitle: '로그인하기',
        barrierDismissible: true,
      );
      if (pressYes.confirmed) _navigationService.navigateTo(Routes.loginView);
      return;
    }
    SheetResponse sheetResponse = await _bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      variant: BottomSheetType.AddToCart,
      customData: {
        'inventoryList': [this.inventory]
      },
    );
    if (sheetResponse.confirmed) {
      sheetResponse.responseData.forEach((Inventory k, int v) async {
        if (v > 0) {
          await _analyticsService.logAddCart(
              id: k.id,
              productName: k.product.name,
              productCategory: k.product.category.toString(),
              quantity: v);
          await this.addToCart(inventoryId: k.id, quantity: v);
        }
      });
    }
    if (product.category == ProductCategory.Salad && sheetResponse.confirmed) {
      SheetResponse sheetResponseForProtein =
          await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.AddToCart,
        customData: {
          'inventoryList':
              _farmViewModel.inventoryMapByCategory[ProductCategory.Protein],
          'needDetailArrow': true,
        },
      );
      if (sheetResponseForProtein.confirmed) {
        sheetResponseForProtein.responseData
            .forEach((Inventory k, int v) async {
          if (v > 0) {
            await _analyticsService.logAddCart(
                id: k.id,
                productName: k.product.name,
                productCategory: k.product.category.toString(),
                quantity: v);
            await this.addToCart(inventoryId: k.id, quantity: v);
          } else {
            return;
          }
        });
      }

      SheetResponse sheetResponseForDressing =
          await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.AddToCart,
        customData: {
          'inventoryList':
              _farmViewModel.inventoryMapByCategory[ProductCategory.Dressing],
          'needDetailArrow': true,
        },
      );

      if (sheetResponse.confirmed) {
        sheetResponseForDressing.responseData
            .forEach((Inventory k, int v) async {
          if (v > 0) {
            await _analyticsService.logAddCart(
                id: k.id,
                productName: k.product.name,
                productCategory: k.product.category.toString(),
                quantity: v);
            await this.addToCart(inventoryId: k.id, quantity: v);
          }
        });
      }
    }
    if (sheetResponse.confirmed) {
      _navigationService.back();
    }
  }
}
