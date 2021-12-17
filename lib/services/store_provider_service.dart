import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/store.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/location_service.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked_services/stacked_services.dart';

class StoreProviderService {
  ServerService _serverService = locator<ServerService>();
  UserProviderService _userProviderService = locator<UserProviderService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  LocationService _locationService = locator<LocationService>();
  CartProviderService _cartProviderService = locator<CartProviderService>();
  Map<ProductCategory, List<Inventory>> inventoryMapByCategory = {
    ProductCategory.Vegetable: <Inventory>[],
    ProductCategory.Salad: <Inventory>[],
    ProductCategory.Grouped: <Inventory>[],
    ProductCategory.Protein: <Inventory>[],
    ProductCategory.Dressing: <Inventory>[],
  };
  bool isPossibleToBuy;
  Store store;

  Map<String, dynamic> getLocationMap<T>({
    T data,
    bool isCoordinates = false,
  }) {
    if (isCoordinates) {
      return {"coordinates": data};
    } else {
      return {"address": data};
    }
  }

  Future<void> getStoreDataFromServer(
      {List<double> coordinates,
      String address,
      bool fromAddressSearch = false}) async {
    try {
      Map<String, dynamic> storeData = {};
      Map<String, dynamic> locationData = {};
      // 둘다 있는 경우
      if ((coordinates != null && coordinates.isNotEmpty) &&
          (address != null && address != '')) {
        locationData = {"coordinates": coordinates, "address": address};
        storeData = await _serverService.postData<Map<String, dynamic>>(
            resource: Resource.stores,
            isOtherDataNeed: true,
            path: '/fromLocation',
            data: locationData);
        //하나만 있는 경우
      } else if ((coordinates != null && coordinates.isNotEmpty) ||
          (address != null && address != '')) {
        if (coordinates != null && coordinates.isNotEmpty) {
          locationData = {"coordinates": coordinates};
        } else {
          locationData = {"address": address};
        }
        storeData = await _serverService.postData<Map<String, dynamic>>(
            resource: Resource.stores,
            isOtherDataNeed: true,
            path: '/fromLocation',
            data: locationData);
        if (storeData["coordinates"] != null) {
          List coordintesList =
              List<double>.from(storeData["coordinates"].map((x) => x));
          if (storeData['address'] != null && coordintesList.isNotEmpty) {
            Address newAddress = new Address(
                address: storeData['address'],
                postcode: storeData['zoneCode'],
                coordinates: coordintesList);
            if (fromAddressSearch) {
              String addressDetail = await callBottomSheetToGetAddressDetail();
              newAddress.addressDetail = addressDetail;
            }
            await _userProviderService.appendAddress(newAddress);
          }
        }
      } else {
        //초기 주소가 없는 경우
        if (_userProviderService.isLogined) {
          List coordinates = await _locationService.getCoordinates();
          if (coordinates.isNotEmpty) {
            locationData = {"coordinates": coordinates};
            storeData = await _serverService.postData<Map<String, dynamic>>(
                resource: Resource.stores,
                isOtherDataNeed: true,
                path: '/fromLocation',
                data: locationData);
            if (storeData["coordinates"] != null) {
              List coordintesList =
                  List<double>.from(storeData["coordinates"].map((x) => x));
              if (storeData['address'] != null && coordintesList.isNotEmpty) {
                await _userProviderService.appendAddress(new Address(
                    address: storeData['address'],
                    postcode: storeData['zoneCode'],
                    coordinates: coordintesList));
              }
            }
          } else {
            //로그인 위치정보 거절
            storeData = await _serverService.postData<Map<String, dynamic>>(
                resource: Resource.stores,
                isOtherDataNeed: true,
                path: '/fromLocation',
                data: {});
          }
        } else {
          storeData = await _serverService.postData<Map<String, dynamic>>(
              resource: Resource.stores,
              isOtherDataNeed: true,
              path: '/fromLocation',
              data: {});
        }
      }
      if (_userProviderService.isLogined) {
        await _cartProviderService.syncCartFromServer();
      }
      this.isPossibleToBuy = storeData['isPossibleToBuy'];
      this.store = Store.fromJson(storeData['data']['data']);
      _setInventories();
    } on APIException catch (e) {
      _dialogService.showDialog(title: "오류", description: e.message);
    } catch (e) {
      debugPrint(e);
      throw e;
    }
  }

  Future<void> getInventoriesWhenUserIsInStore(String storeId) async {
    dynamic storeData = await _serverService.getData(
        resource: Resource.stores, path: '/inStore/$storeId');
    this.isPossibleToBuy = true;
    this.store = Store.fromJson(storeData);
    _setInventories();
  }

  void _setInventories() {
    if (this.store != null) {
      inventoryMapByCategory = {
        ProductCategory.Vegetable: <Inventory>[],
        ProductCategory.Salad: <Inventory>[],
        ProductCategory.Grouped: <Inventory>[],
        ProductCategory.Protein: <Inventory>[],
        ProductCategory.Dressing: <Inventory>[],
      };
      this.store.inventories.forEach((element) {
        switch (element.product.category) {
          case ProductCategory.Vegetable:
            return inventoryMapByCategory[ProductCategory.Vegetable]
                .add(element);
          case ProductCategory.Salad:
            return inventoryMapByCategory[ProductCategory.Salad].add(element);
          case ProductCategory.Grouped:
            return inventoryMapByCategory[ProductCategory.Grouped].add(element);
          case ProductCategory.Protein:
            return inventoryMapByCategory[ProductCategory.Protein].add(element);
          case ProductCategory.Dressing:
            return inventoryMapByCategory[ProductCategory.Dressing]
                .add(element);
          default:
            return inventoryMapByCategory[ProductCategory.Vegetable]
                .add(element);
        }
      });
    }
  }

  Future<String> callBottomSheetToGetAddressDetail() async {
    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.Write,
        customData: {
          'maxLength': 20,
          'keyboardType': TextInputType.streetAddress,
          'hintText': '상세주소를 입력해주세요'
        },
        title: '상세주소');
    if (_sheetResponse.confirmed) {
      return _sheetResponse.responseData['input'].trim();
    } else {
      DialogResponse res = await _dialogService.showConfirmationDialog(
          title: "알림",
          description: "상세주소는 안전한 배송을 위해서 필수사항입니다.정말 건너뛰시겠습니까?",
          barrierDismissible: false,
          confirmationTitle: "기입하기",
          cancelTitle: "건너뛰기");
      if (res.confirmed) {
        return callBottomSheetToGetAddressDetail();
      } else {
        return '';
      }
    }
  }
}
