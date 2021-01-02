import 'package:flutter/foundation.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/repository/auth_page_repository/kakao_auth_repository.dart';
import 'package:liv_farm/repository/landing_page_repository.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPageViewModel with ChangeNotifier {
  bool isBusy = true;
  MyUser user;
  String accessToken;
  KaKaoAuthRepository _kaKaoAuthRepository = KaKaoAuthRepository();

  LandingPageRepository _landingPageRepository = LandingPageRepository();

  LandingPageViewModel() {
    //Future가 위에서 걸려있어도 무조건 이친구부터 싪행이 된다.
    log.methodLog(method: 'init of LandingPageViewModel');
    Future.microtask(() async => await getUserDataWhenAppStart());
  }

  void userStatusChanged(user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _landingPageRepository.clearLocalData();
      userStatusChanged(null);
    } catch (e) {
      return null;
    }
  }

  Future<void> getUserDataWhenAppStart() async {
    // SharedPreferences _pref = await SharedPreferences.getInstance();
    // _pref.clear();
    int uid = await _landingPageRepository.getDataFromLocal();
    

    if (uid == null) {
      isBusy = false;
      notifyListeners();
      return;
    } else {
      user = await _landingPageRepository.getMyUserInitially(uid);
      isBusy = false;
      notifyListeners();
      return;
    }
  }
}
