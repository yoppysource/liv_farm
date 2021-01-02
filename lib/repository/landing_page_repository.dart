import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPageRepository {
  
  Future<int> getDataFromLocal() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      String accessToken = _pref.getString(KEY_access_token);
      int uid = _pref.getInt(KEY_customer_uid);

      if (uid != null) {
        API.accessToken = accessToken;
        print(accessToken);
        return uid;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> clearLocalData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
  }

  Future<MyUser> getMyUserInitially(int uid) async {
    Map<String, dynamic> data = await ServerService(
            api: API(endpoint: Endpoint.customers))
        .getData(params1: '/${uid.toString()}');
    if (data[MSG] == MSG_success) {
      return MyUser.fromJson(data: data['result']);
    } else{
        return null;
    }
  }
}
