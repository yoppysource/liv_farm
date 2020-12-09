import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/repository/location_repository.dart';

class HomePageViewModel with ChangeNotifier {
  MyUser user;
  HomePageViewModel({@required this.user});

  LocationRepository _locationRepository =LocationRepository();
  //TODO:location기반 만들기!!
  // Future<bool> isAvailableFromCurrentLocation() async {
  //   await _locationRepository.getCurrentLocation();
  //   if()
  // }
}