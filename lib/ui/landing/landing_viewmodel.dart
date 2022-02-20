import 'dart:io';
import 'package:flutter/services.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/server_service/api_exception.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/store_provider_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/farm/online_farm/online_farm_viewmodel.dart';
import 'package:liv_farm/ui/home/home_main/event_banner/event_banner_view.dart';
import 'package:package_info/package_info.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:store_redirect/store_redirect.dart';

enum Version { fit, needToBeUpdated, fail }

class LandingViewModel extends FutureViewModel {
  final ClientService _serverService = locator<ClientService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final UserProviderService _userProviderService =
      locator<UserProviderService>();
  final DialogService _dialogService = locator<DialogService>();
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();
  final StoreProviderService _storeProviderService =
      locator<StoreProviderService>();
  final OnlineFarmViewModel _onlineFarmViewModel =
      locator<OnlineFarmViewModel>();
  final EventBannerViewModel _eventBannerViewModel =
      locator<EventBannerViewModel>();
  // final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  @override
  Future futureToRun() async {
    //First, check version information
    // There should be case for reload when user
    // login/sign up after the application already have run
    // In that case the user must be something else and only refetch the inventory data is needed
    if (_userProviderService.user == null) {
      Version? versionCheck = await _checkVersion();
      if (versionCheck != Version.fit) {
        await _showDialogForVersionCheckResult(versionCheck!);
      }
      //Second, check user has JWT Token and it is vaild
    }
    await _setAppInitially();
    String? isOnBoarding =
        await _secureStorageService.getValueFromStorage(key: keyOnBoarding);

    return isOnBoarding == null
        ? _navigationService.replaceWith(Routes.videoView)
        : _navigationService.replaceWith(Routes.homeView);
  }

  Future<void> _setAppInitially() async {
    // await _dynamicLinkService.handleDynamicLinks();
    // String? storeId =
    //     await _secureStorageService.getValueFromStorage(key: KEY_IN_STORE);
    // if (storeId != '') {
    //   await _inOffineStoreService.switchToOffineMode(storeId);
    // }
    String? jwt = await _secureStorageService.getValueFromStorage(key: KEY_JWT);
    if (jwt != null) {
      ClientService.accessToken = jwt;
      try {
        Map<String, dynamic> data = await _serverService.sendRequest(
            method: HttpMethod.get, resource: Resource.users, endPath: '/me');
        if (data['isEmailConfirmed'] == false) {
          await _serverService.sendRequest(
              method: HttpMethod.post,
              resource: Resource.auth,
              endPath: '/confirmationEmail',
              data: {"email": _userProviderService.user!.email});
          await _dialogService.showDialog(
            title: '이메일 인증',
            description: "가입하신 이메일 메일함에서 이메일 주소를 인증하고, 다시 로그인해주세요",
            buttonTitle: '확인',
            barrierDismissible: false,
          );
        } else {
          _userProviderService.setUserFromJson(data);
        }
      } on APIException catch (e) {
        // //invaild uid
        // await _storeProviderService.getStoreDataFromServer();
        if (e.statusCode != 401) {
          _dialogService.showDialog(
              title: "안내", description: e.message, buttonTitle: "확인");
        }
        // return;
      } catch (e) {
        // //invaild uid
        // await _storeProviderService.getStoreDataFromServer();
        _dialogService.showDialog(
            title: "안내", description: "오류가 발생했습니다.", buttonTitle: "확인");
        // return;
      }
    }
    await _storeProviderService.setStoreInitially();
    await _onlineFarmViewModel.getInventories();
    await _eventBannerViewModel.getEvent();

    //   try {
    //     // Email confirm이 안된경우
    //     if (_userProviderService.user!.isEmailConfirmed != null &&
    //         !_userProviderService.user!.isEmailConfirmed!) {
    //       await _serverService.sendRequest(
    //           method: HttpMethod.post,
    //           resource: Resource.auth,
    //           endPath: '/confirmationEmail',
    //           data: {"email": _userProviderService.user!.email});
    //       await _dialogService.showDialog(
    //         title: '이메일 인증',
    //         description: "가입하신 이메일 메일함에서 이메일 주소를 인증하고, 다시 로그인해주세요",
    //         buttonTitle: '확인',
    //         barrierDismissible: false,
    //       );
    //       await _userProviderService.logout();
    //       return _navigationService.replaceWith(Routes.homeView);
    //     }
    //   } on APIException catch (e) {
    //     debugPrint(e.message);
    //     _dialogService.showDialog(
    //         title: "안내", description: e.message, buttonTitle: "확인");
    //   }
    // }

    // if (jwt == null) {
    //   //1) 로그인이 안되있을 경우
    //   await _storeProviderService.getStoreDataFromServer();
    // } else {
    //   ClientService.accessToken = jwt;
    //   try {
    //     Map<String, dynamic> data = await _serverService.sendRequest(
    //         method: HttpMethod.get, resource: Resource.users, endPath: '/me');
    //     _userProviderService.setUserFromJson(data);
    //   } on APIException catch (e) {
    //     //invaild uid
    //     await _storeProviderService.getStoreDataFromServer();
    //     _dialogService.showDialog(
    //         title: "안내", description: e.message, buttonTitle: "확인");
    //     return;
    //   } catch (e) {
    //     //invaild uid
    //     await _storeProviderService.getStoreDataFromServer();
    //     _dialogService.showDialog(
    //         title: "안내", description: "오류가 발생했습니다.", buttonTitle: "확인");
    //     return;
    //   }
    //   try {
    //     // Email confirm이 안된경우
    //     if (_userProviderService.user!.isEmailConfirmed != null &&
    //         !_userProviderService.user!.isEmailConfirmed!) {
    //       await _serverService.sendRequest(
    //           method: HttpMethod.post,
    //           resource: Resource.auth,
    //           endPath: '/confirmationEmail',
    //           data: {"email": _userProviderService.user!.email});
    //       await _dialogService.showDialog(
    //         title: '이메일 인증',
    //         description: "가입하신 이메일 메일함에서 이메일 주소를 인증하고, 다시 로그인해주세요",
    //         buttonTitle: '확인',
    //         barrierDismissible: false,
    //       );
    //       await _userProviderService.logout();
    //       return _navigationService.replaceWith(Routes.homeView);
    //     }
    //   } on APIException catch (e) {
    //     debugPrint(e.message);
    //     _dialogService.showDialog(
    //         title: "안내", description: e.message, buttonTitle: "확인");
    //   }
    // }
  }

  // Future<void> _getInventoriesFromStore() async {
  //   if (_userProviderService.user?.addresses!.isNotEmpty ?? false) {
  //     await _storeProviderService.getStoreDataFromServer(
  //         coordinates: _userProviderService.user!.addresses![0].coordinates,
  //         address: _userProviderService.user!.addresses![0].address);
  //   } else {
  //     await _storeProviderService.getStoreDataFromServer();
  //   }
  // }

  // void _setStreamingURL(String streamingURL) {
  //   StreamingView.streamingURL = streamingURL;
  // }

  Future<Version?> _checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String installed = packageInfo.version.toString();
    try {
      Map<String, dynamic> data = await _serverService.sendRequest(
          method: HttpMethod.get,
          resource: Resource.appinfo,
          endPath: '/appInfo');
      if (data["inMaintenance"] == true) return Version.fail;

      List<int?> currentAppVersion =
          installed.split('.').map((e) => int.tryParse(e)).toList();
      List<int?> requiredAppVersion = data['version']
          .toString()
          .split('.')
          .map((e) => int.tryParse(e))
          .toList();
      if (currentAppVersion[0]! < requiredAppVersion[0]!) {
        return Version.needToBeUpdated;
      }
      if (currentAppVersion[1]! < requiredAppVersion[1]!) {
        return Version.needToBeUpdated;
      }
      if (currentAppVersion[2]! < requiredAppVersion[2]!) {
        return Version.needToBeUpdated;
      }
      // _setStreamingURL(data['streamingURL']);
      return Version.fit;
    } catch (e) {
      await _dialogService.showDialog(
        title: '오류',
        description: '오류가 발생했습니다. 인터넷 연결을 확인해주세요.',
        buttonTitle: '확인',
        barrierDismissible: false,
      );
      _killApp();
    }
  }

  Future<void> _showDialogForVersionCheckResult(Version version) async {
    await _dialogService.showDialog(
      title: '알림',
      description: version == Version.fail
          ? '현재 서버 점검 중입니다. 잠시 후에 다시 시도해주세요. 불편을 드려 죄송합니다'
          : '사용하시는 버전이 너무 낮습니다.\n안전한 쇼핑을 위해 앱을 업데이트 해주세요.',
      buttonTitle: '확인',
      barrierDismissible: false,
    );
    version == Version.fail
        ? _killApp()
        : await StoreRedirect.redirect(
            androidAppId: "com.future_connect.liv_farm",
            iOSAppId: "1550565167");
    _killApp();
  }

  void _killApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }
}
