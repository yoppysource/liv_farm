import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/app/app.router.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/home_view.dart';
import 'package:liv_farm/ui/landing/video_view.dart';
import 'package:stacked/stacked.dart';
import 'package:package_info/package_info.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:store_redirect/store_redirect.dart';

enum Version { fit, needToBeUpdated, fail }

class LandingViewModel extends FutureViewModel {
  ServerService _serverServiceForAppInfo =
      ServerService(apiPath: APIPath(resource: Resource.appinfo));
  NavigationService _navigationService = locator<NavigationService>();
  UserProviderService _userProviderService = locator<UserProviderService>();
  DialogService _dialogService = locator<DialogService>();
  SecureStorageService _secureStorageService = locator<SecureStorageService>();
  ServerService _serverServiceForUser =
      ServerService(apiPath: APIPath(resource: Resource.users));
  @override
  Future futureToRun() async {
    //First, check version information
    Version versionCheck = await _checkVersion();
    print(versionCheck);
    if (versionCheck != Version.fit)
      await _showDialogForVersionCheckResult(versionCheck);
    //Second, check user has JWT Token and it is vaild
    await _setUserInitially();
    return _navigationService.replaceWith(Routes.homeView);
  }

  Future<void> _setUserInitially() async {
    String jwt = await _secureStorageService.getTokenFromStorage();
    if (jwt == '') return false;
    ServerService.accessToken = jwt;
    try {
      Map<String, dynamic> data =
          await _serverServiceForUser.getData(path: '/me');
      _userProviderService.setUserFromJson(data["data"]);
    } on APIException catch (e) {
      _dialogService.showDialog(
          title: "안내", description: e.message, buttonTitle: "확인");
    }
  }

  Future<Version> _checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String installed = packageInfo.version.toString();
    print(installed);
    try {
      Map<String, dynamic> data =
          await _serverServiceForAppInfo.getData(path: '/appInfo');
      if (data['data']["inMaintenance"] == true) return Version.fail;

      List<int> currentAppVersion =
          installed.split('.').map((e) => int.tryParse(e)).toList();
      List<int> requiredAppVersion = data["data"]['version']
          .toString()
          .split('.')
          .map((e) => int.tryParse(e))
          .toList();
      if (currentAppVersion[0] < requiredAppVersion[0])
        return Version.needToBeUpdated;
      if (currentAppVersion[1] < requiredAppVersion[1])
        return Version.needToBeUpdated;
      if (currentAppVersion[2] < requiredAppVersion[2])
        return Version.needToBeUpdated;

      return Version.fit;
    } catch (e) {
      await _dialogService.showDialog(
        title: '오류',
        description: '오류가 발생했습니다. 인터넷 연결을 확인해주세요.',
        buttonTitle: '확인',
        barrierDismissible: false,
      );
      _killApp();
      return null;
    }
  }

  Future<void> _showDialogForVersionCheckResult(Version version) async {
    await _dialogService.showDialog(
      title: '알림',
      description: version == Version.fail
          ? '오류가 발생했습니다. 인터넷 연결을 확인해주세요.'
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
