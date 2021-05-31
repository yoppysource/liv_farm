import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/farm/farm_viewmodel.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductDetailViewModel extends FutureViewModel {
  Product product;
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  FarmViewModel _farmViewModel = locator<FarmViewModel>();
  DialogService _dialogService = locator<DialogService>();
  ServerService _serverService =
      ServerService(apiPath: APIPath(resource: Resource.products));
  UserProviderService _userProviderService = locator<UserProviderService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  NavigationService _navigationService = locator<NavigationService>();
  ShoppingCartViewModel _shoppingCartViewModel =
      locator<ShoppingCartViewModel>();

  ProductDetailViewModel({@required this.product});

  @override
  Future<void> futureToRun() async {
    try {
      Map<String, dynamic> data =
          await _serverService.getData(path: "/${this.product.id}");
      product = Product.fromJson(data["data"]);
    } catch (e) {
      print(e);
      ToastMessageService.showToast(message: "상품정보를 가져오는데 실패하였습니다.");
    }
  }

  void onBackPressed() {
    _navigationService.back();
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
        'productList': [this.product]
      },
    );
    if (sheetResponse.confirmed) {
      sheetResponse.responseData.forEach((Product k, v) async {
        await _analyticsService.logAddCart(
            id: k.id,
            productName: k.name,
            productCategory: k.category.toString(),
            quantity: v);

        await _shoppingCartViewModel.addToCart(productId: k.id, quantity: v);
      });
    }
    if (product.category == ProductCategory.Salad && sheetResponse.confirmed) {
      SheetResponse sheetResponseForProtein =
          await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.AddToCart,
        customData: {
          'productList': _farmViewModel.data[ProductCategory.Protein],
          'needDetailArrow': true,
        },
      );
      if (sheetResponseForProtein.confirmed) {
        sheetResponseForProtein.responseData.forEach((k, v) async {
          if (v > 0) {
            await _analyticsService.logAddCart(
                id: k.id,
                productName: k.name,
                productCategory: k.category.toString(),
                quantity: v);
            await _shoppingCartViewModel.addToCart(
                productId: k.id, quantity: v);
          }
        });
      }

      SheetResponse sheetResponseForDressing =
          await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.AddToCart,
        customData: {
          'productList': _farmViewModel.data[ProductCategory.Dressing],
          'needDetailArrow': true,
        },
      );

      if (sheetResponse.confirmed) {
        sheetResponseForDressing.responseData.forEach((k, v) async {
          if (v > 0) {
            await _analyticsService.logAddCart(
                id: k.id,
                productName: k.name,
                productCategory: k.category.toString(),
                quantity: v);
            await _shoppingCartViewModel.addToCart(
                productId: k.id, quantity: v);
          }
        });
      }
    }
    if (sheetResponse.confirmed) {
      await Future.delayed(const Duration(milliseconds: 500));
      _navigationService.back();
    }
  }
}
