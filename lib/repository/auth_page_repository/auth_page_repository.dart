import 'dart:convert';

import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPageRepository {
  String accessToken;
  int uid;
  ServerService serverService =
      ServerService(api: API(endpoint: Endpoint.login));

  Future<MyUser> getMyUserFromServer(Map<String, dynamic> initialData) async {
    print('token');
    print('${initialData.toString()}');
    Map<String, dynamic> result =
        await serverService.postData(data: initialData);
    if (result[MSG] == MSG_success) {
      print('${result['token']}');
      accessToken = result['token'];
      uid = result['result'][KEY_customer_uid];
      API.accessToken = accessToken;
      Map<String, dynamic> data = result['result'] as Map;
      print('$accessToken');
      return MyUser.fromJson(data: data);
    } else {
      print('issue token fail');
      return null;
    }
  }
  Map<String, dynamic> createInitialData(String id, String platformInfo){
    print(id);
    Map<String, dynamic> initialData = Map();
    initialData[KEY_customer_snsId] = id;
    initialData[KEY_customer_platform] = platformInfo;

    return initialData;
  }



  Future<bool> saveAccessTokenToLocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (accessToken != null) {
      await pref.setString(KEY_access_token, accessToken);
      print(uid.toString());
      await pref.setInt(KEY_customer_uid, uid);
      return true;
    }
    return false;
  }
}
