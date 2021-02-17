import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:liv_farm/model/customer_log.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';
import 'package:package_info/package_info.dart';

class CustomerLogRepository {
  final int userId;

  CustomerLogRepository(this.userId);
  ServerService _serverService = ServerService(
    api: API(
      endpoint: Endpoint.customerLogs,
    ),
  );

  Future<void> sendLogDataToServer() async {
    final String os = await AppleSignIn.isAvailable() == true ? 'Ios' : 'Android';
    final PackageInfo info = await PackageInfo.fromPlatform();
    final String version =  info.version;
    // final Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    CustomerLog log = new CustomerLog(
      customerId: this.userId,
      // lng: currentPosition.longitude,
      // lat: currentPosition.latitude,
      appVersion: version,
      loginOS: os,
    );
   await  _serverService.postData(data: log.toJson());
  }
}
