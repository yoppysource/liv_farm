import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  // If it is fail to get data based on user location it will
  Future<List> getCoordinates() async {
    try {
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          return [];
        }
      }

      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return [];
        }
      }

      _locationData = await _location.getLocation();
      return [_locationData.longitude, _locationData.latitude];
    } catch (e) {
      return [];
    }
  }
}
