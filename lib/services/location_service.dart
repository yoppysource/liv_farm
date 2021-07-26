import 'package:location/location.dart';

class LocationService {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  // If it is fail to get data based on user location it will
  Future<List> getCoordinates() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return new List();
        }
      }

      _permissionGranted = await location.hasPermission();
      print(_permissionGranted);
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return new List();
        }
      }

      _locationData = await location.getLocation();
      return [_locationData.longitude, _locationData.latitude];
    } catch (e) {
      print(e.message);
      return new List();
    }
  }
}
