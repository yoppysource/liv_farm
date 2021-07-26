import 'package:liv_farm/model/inventory.dart';

class Store {
  bool takeOut;
  bool isOpenSaturday;
  bool isOpenSunday;
  bool isOpenToday;
  String openHourStr;
  String closeHourStr;
  String sId;
  String name;
  String address;
  List<Inventory> inventories;
  String id;

  Store(
      {
      this.takeOut,
      this.isOpenSaturday,
      this.isOpenSunday,
      this.isOpenToday,
      this.openHourStr,
      this.closeHourStr,
      this.name,
      this.address,
      this.inventories,
      this.id});

  Store.fromJson(Map<String, dynamic> json) {
    takeOut = json['takeOut'];
    isOpenSaturday = json['isOpenSaturday'];
    isOpenSunday = json['isOpenSunday'];
    isOpenToday = json['isOpenToday'];
    openHourStr = json['openHourStr'];
    closeHourStr = json['closeHourStr'];
    name = json['name'];
    address = json['address'];
    if (json['inventories'] != null) {
      inventories = new List<Inventory>();
      json['inventories'].forEach((v) {
        inventories.add(new Inventory.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['takeOut'] = this.takeOut;
    data['isOpenSaturday'] = this.isOpenSaturday;
    data['isOpenSunday'] = this.isOpenSunday;
    data['isOpenToday'] = this.isOpenToday;
    data['openHourStr'] = this.openHourStr;
    data['closeHourStr'] = this.closeHourStr;
    data['name'] = this.name;
    data['address'] = this.address;
    if (this.inventories != null) {
      data['inventories'] = this.inventories.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}
