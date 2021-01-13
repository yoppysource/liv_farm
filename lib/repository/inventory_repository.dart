import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';

class InventoryRepository {
  ServerService _serverService = ServerService(
    api: API(
      endpoint: Endpoint.inventories,
    ),
  );

  Future<int> getInventoryNum(int productId) async {
    Map data = await _serverService.getData(params1: '/$productId');

    if(data[MSG] == MSG_success){
      if(data[KEY_Result].isEmpty){
        return 0;
      }
     return data[KEY_Result][0]["quantity"];
    }
    else{
      return 0;
    }
  }
}