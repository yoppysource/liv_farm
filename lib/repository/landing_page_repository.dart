import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPageRepository {
  Future<String> getAccessTokenFromLocal() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      String accessToken = _pref.getString(KEY_access_token);
      if (accessToken != null) {
        API.accessToken = accessToken;
        return accessToken;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<MyUser> getMyUserInitially() async {
    Map<String, dynamic> data = await ServerService(
            api: API(endpoint: Endpoint.customers))
        .getData();
    if (data[MSG] == MSG_success) {
      API.accessToken = data['token'];

      return MyUser.fromJson(data: data['result']);
    } else {
      API.accessToken = data['token'];
      return null;
    }
  }
}
