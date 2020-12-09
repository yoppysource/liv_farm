import 'package:flutter/cupertino.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';

class UserInformationRepository {
  ServerService _serverService =
      ServerService(api: API(endpoint: Endpoint.customers));

  Future<Map<String, dynamic>> updateUserData({@required userData, @required userId}) async {
    dynamic data =  await _serverService.postData(data: userData, params1: '/$userId') as Map;
    return data;
  }
}
