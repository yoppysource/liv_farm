import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/model/store.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/location_service.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked_services/stacked_services.dart';

class StoreProviderService {
  final ClientService _serverService = locator<ClientService>();
  final UserProviderService _userProviderService =
      locator<UserProviderService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final LocationService _locationService = locator<LocationService>();
  final CartProviderService _cartProviderService =
      locator<CartProviderService>();

  List<Store>? _storeList;
  List<Store>? get storeList => _storeList;

  Store? get store => _storeList?[0];

  // set
  Future<void> setStoreInitially() async {
    if (_userProviderService.isLogined) {
      if (_userProviderService.user!.addresses!.isNotEmpty &&
          _userProviderService.user!.addresses![0].coordinates != null) {
        Address _userAddress = _userProviderService.user!.addresses![0];
        await setStoreListBasedOnCoordinates(_userAddress.coordinates!);
      } else {
        List coordinates = await _locationService.getCoordinates();
        if (coordinates.isNotEmpty) {
          await setStoreListBasedOnCoordinates(coordinates);
        } else {
          await setStoreListFromServer();
        }
      }
      if (_userProviderService.user?.cart.storeId != null) {
        Store preferredStore = _storeList!.firstWhere((Store store) =>
            store.id == _userProviderService.user?.cart.storeId);
        _storeList!.remove(preferredStore);
        _storeList!.insert(0, preferredStore);
      }
    } else {
      List coordinates = await _locationService.getCoordinates();
      if (coordinates.isNotEmpty) {
        await setStoreListBasedOnCoordinates(coordinates);
      } else {
        await setStoreListFromServer();
        await selectShopByBottomSheet();
      }
    }
    _cartProviderService.updateCartWhenStoreSet(store!.id);
  }

  Future<void> setStoreListFromServer() async {
    List storeDataList = await _serverService.sendRequest<List>(
      method: HttpMethod.get,
      resource: Resource.stores,
    );
    _storeList = storeDataList.map((e) => Store.fromJson(e)).toList();
  }

  Future<void> setStoreListBasedOnCoordinates(List coordinates) async {
    List storeDataList = await _serverService.sendRequest<List>(
        method: HttpMethod.post,
        resource: Resource.stores,
        endPath: '/coordinates',
        data: {"coordinates": coordinates});
    _storeList = storeDataList.map((e) => Store.fromJson(e)).toList();
  }

  Future<void> selectShopByBottomSheet() async {
    if (_storeList != null && _storeList!.isNotEmpty) {
      SheetResponse? _sheetResponse =
          await _bottomSheetService.showCustomSheet<int, List<Store>>(
              variant: BottomSheetType.storeSelection, data: _storeList);
      if (_sheetResponse != null && _sheetResponse.confirmed == true) {
        int index = _sheetResponse.data;
        if (index != 0) {
          Store removed = _storeList!.removeAt(index);
          _storeList!.insert(0, removed);
        }
      }
    }
  }

  Future<void> setStoresWhenAddressChange(Address address) async {
    await setStoreListBasedOnCoordinates(address.coordinates!);
    if (_userProviderService.user?.cart.storeId != null) {
      Store preferredStore = _storeList!.firstWhere(
          (Store store) => store.id == _userProviderService.user?.cart.storeId);
      _storeList!.remove(preferredStore);
      _storeList!.insert(0, preferredStore);
    }
  }

  // Map<String, dynamic> getLocationMap<T>({
  //   required T data,
  //   bool isCoordinates = false,
  // }) {
  //   if (isCoordinates) {
  //     return {"coordinates": data};
  //   } else {
  //     return {"address": data};
  //   }
  // }

  // Future<void> getStoreDataFromServer(
  //     {List<double>? coordinates,
  //     String? address,
  //     bool fromAddressSearch = false}) async {
  //   try {
  //     Map<String, dynamic> storeData = {};
  //     Map<String, dynamic> locationData = {};
  //     // 둘다 있는 경우
  //     if ((coordinates != null && coordinates.isNotEmpty) &&
  //         (address != null && address != '')) {
  //       locationData = {"coordinates": coordinates, "address": address};
  //       storeData = await _serverService.sendRequest<Map<String, dynamic>>(
  //           method: HttpMethod.post,
  //           resource: Resource.stores,
  //           getAllData: true,
  //           endPath: '/fromLocation',
  //           data: locationData);
  //       //하나만 있는 경우
  //     } else if ((coordinates != null && coordinates.isNotEmpty) ||
  //         (address != null && address != '')) {
  //       if (coordinates != null && coordinates.isNotEmpty) {
  //         locationData = {"coordinates": coordinates};
  //       } else {
  //         locationData = {"address": address};
  //       }
  //       storeData = await _serverService.sendRequest<Map<String, dynamic>>(
  //           method: HttpMethod.post,
  //           resource: Resource.stores,
  //           getAllData: true,
  //           endPath: '/fromLocation',
  //           data: locationData);
  //       if (storeData["coordinates"] != null) {
  //         List<double> coordintesList =
  //             List<double>.from(storeData["coordinates"].map((x) => x));
  //         if (storeData['address'] != null && coordintesList.isNotEmpty) {
  //           Address newAddress = Address(
  //               address: storeData['address'],
  //               postcode: storeData['zoneCode'],
  //               coordinates: coordintesList);
  //           if (fromAddressSearch) {
  //             String addressDetail = await callBottomSheetToGetAddressDetail();
  //             newAddress.addressDetail = addressDetail;
  //           }
  //           await _userProviderService.appendAddress(newAddress);
  //         }
  //       }
  //     } else {
  //       //초기 주소가 없는 경우
  //       if (_userProviderService.isLogined) {
  //         List coordinates = await _locationService.getCoordinates();
  //         if (coordinates.isNotEmpty) {
  //           locationData = {"coordinates": coordinates};
  //           storeData = await _serverService.sendRequest<Map<String, dynamic>>(
  //               method: HttpMethod.post,
  //               resource: Resource.stores,
  //               getAllData: true,
  //               endPath: '/fromLocation',
  //               data: locationData);
  //           if (storeData["coordinates"] != null) {
  //             List<double> coordintesList =
  //                 List<double>.from(storeData["coordinates"].map((x) => x));
  //             if (storeData['address'] != null && coordintesList.isNotEmpty) {
  //               await _userProviderService.appendAddress(Address(
  //                   address: storeData['address'],
  //                   postcode: storeData['zoneCode'],
  //                   coordinates: coordintesList));
  //             }
  //           }
  //         } else {
  //           //로그인 위치정보 거절
  //           storeData = await _serverService.sendRequest<Map<String, dynamic>>(
  //               method: HttpMethod.post,
  //               resource: Resource.stores,
  //               getAllData: true,
  //               endPath: '/fromLocation',
  //               data: {});
  //         }
  //       } else {
  //         storeData = await _serverService.sendRequest<Map<String, dynamic>>(
  //             method: HttpMethod.post,
  //             resource: Resource.stores,
  //             getAllData: true,
  //             endPath: '/fromLocation',
  //             data: {});
  //       }
  //     }
  //     if (_userProviderService.isLogined) {
  //       // await _cartProviderService.syncCartFromServer();
  //     }
  //     // isPossibleToBuy = storeData['isPossibleToBuy'];
  //     // store = Store.fromJson(storeData['data']['data']);
  //     // _setInventories();
  //   } on APIException catch (e) {
  //     _dialogService.showDialog(title: "오류", description: e.message);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<void> getInventoriesWhenUserIsInStore(String storeId) async {
  //   dynamic storeData = await _serverService.sendRequest<Map<String, dynamic>>(
  //       method: HttpMethod.get,
  //       resource: Resource.stores,
  //       endPath: '/inStore/$storeId');

  //   isPossibleToBuy = true;
  //   store = Store.fromJson(storeData);
  //   _setInventories();
  // }

}
