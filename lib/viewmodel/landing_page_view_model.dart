import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/repository/landing_page_repository.dart';
import 'package:liv_farm/service/analytic_service.dart';
import 'package:liv_farm/utill/get_it.dart';
class LandingPageViewModel with ChangeNotifier {
  bool isBusy = true;
  bool needToBeUpdated = false;
  MyUser user;
  String accessToken;
  Version version;

  LandingPageRepository _landingPageRepository = LandingPageRepository();

  LandingPageViewModel() {
    Future.microtask(()async => await getUserDataWhenAppStart());
  }


  void userStatusChanged(user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      // await _firebaseAuth.signOut();
      await _landingPageRepository.clearLocalData();
      userStatusChanged(null);
    } catch (e) {
      return null;
    }
  }

  Future<void> getUserDataWhenAppStart() async {
    await locator<AnalyticsService>().logAppOpen();
    version = await _landingPageRepository.checkVersion();

    int uid = await _landingPageRepository.getDataFromLocal();
    if (uid == null) {
      isBusy = false;
      notifyListeners();
      return;
    } else {
      user = await _landingPageRepository.getMyUserInitially(uid);
      await locator<AnalyticsService>().setUserProperties(userId: uid.toString());
      isBusy = false;
      notifyListeners();
      return;
    }
  }
}
