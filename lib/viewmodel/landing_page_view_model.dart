import 'package:flutter/foundation.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/repository/landing_page_repository.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPageViewModel with ChangeNotifier {
  bool isBusy = true;
  MyUser user;
  String accessToken;

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

  Future<void> getUserDataWhenAppStart() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
    accessToken = await _landingPageRepository.getAccessTokenFromLocal();
    if (accessToken == null) {
      isBusy = false;
      notifyListeners();
      return;
    } else {
      user = await _landingPageRepository.getMyUserInitially();
      isBusy = false;
      notifyListeners();
      return;
    }
  }
}
