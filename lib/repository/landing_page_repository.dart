import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
enum Version {
  fit,
  needToBeUpdated,
  fail
}
class LandingPageRepository {
  //버전 정보 확인하고 다이얼로그로
  //구글 스토어/앱 스토어 스키마 전달하기.
  // 스키마는 앱의 주소, 앱에서 다른 앱을 열여면 필요하다. ios/android 분기해서 url launcher 같은 것을 넘겨줘야한다.
  ServerService versionService = ServerService(api: API(endpoint: Endpoint.version));

  Future<Version> checkVersion() async {
    PackageInfo packageInfo =await PackageInfo.fromPlatform();
    String installed = packageInfo.version.toString();
    Map<String, dynamic> data = await versionService.getData();
    print(data);

    if(data[MSG] == MSG_fail){
      return Version.fail;
    }else{
      List<int> a = installed.toString().split('.').map((e) => int.tryParse(e)).toList();
      List<int> b = data['minversion'].toString().split('.').map((e) => int.tryParse(e)).toList();
      if(a[0]<b[0]) return Version.needToBeUpdated;
      if(a[1]<b[1]) return Version.needToBeUpdated;
      if(a[2]<b[2]) return Version.needToBeUpdated;

      return Version.fit;
    }
  }
  Future<int> getDataFromLocal() async {
    try {
      //asset image => sharedPreferences로 저장.
      SharedPreferences _pref = await SharedPreferences.getInstance();
      // Sql lite, safeStorage, hive => 저장하기.
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
