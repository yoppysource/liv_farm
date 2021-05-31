import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/address.dart';

class MyUser {
  bool agreeToGetMail;
  String role;
  int point;
  String id;
  String email;
  String snsId;
  String platform;
  String name;
  DateTime birthday;
  String gender;
  String phoneNumber;
  List<Address> addresses;
  List<Coupon> coupons;
  Cart cart;

  MyUser(
      {this.agreeToGetMail,
      this.role,
      this.point,
      this.id,
      this.email,
      this.snsId,
      this.birthday,
      this.platform,
      this.name,
      this.gender,
      this.phoneNumber,
      this.addresses,
      this.coupons,
      this.cart});

  MyUser.fromJson(Map<String, dynamic> json) {
    agreeToGetMail = json['agreeToGetMail'];
    if (json['gender'] != null) gender = json['gender'];
    if (json['role'] != null) role = json['role'];
    point = json['point'];
    id = json['_id'];
    if (json['name'] != null) name = json['name'];
    if (json['email'] != null) email = json['email'];
    snsId = json["snsId"];
    platform = json["platform"];
    if (json["birthday"] != null)
      this.birthday = DateTime.tryParse(json["birthday"]);
    phoneNumber = json["phoneNumber"];
    if (json['addresses'] != null) {
      addresses = [];
      json['addresses'].forEach((v) {
        addresses.add(new Address.fromJson(v));
      });
    }
    if (json['coupons'] != null) {
      coupons = [];
      json['coupons'].forEach((v) {
        if (!v['used']) coupons.add(new Coupon.fromJson(v));
      });
    }
    if (json['cart'] != null) cart = new Cart.fromJson(json['cart']);
  }

//ToJson must be relevant to the updating. Thus it is worth to secure the data which is not allowed to change.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agreeToGetMail'] = this.agreeToGetMail ?? false;
    if (this.phoneNumber != null) data['phoneNumber'] = this.phoneNumber;
    if (this.gender != null) data['gender'] = this.gender;
    if (this.birthday != null)
      data['birthday'] = this.birthday.toIso8601String();
    if (this.name != null) data['name'] = this.name;
    data['updatedAt'] = DateTime.now().toIso8601String();
    if (this.addresses != null && this.addresses.isNotEmpty) {
      data['addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
