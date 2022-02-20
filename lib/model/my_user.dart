import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/model/address.dart';

class MyUser {
  late final String id;
  late final String role;
  late final bool isEmailConfirmed;
  late final int point;
  late final List<Coupon> coupons;
  late final Cart cart;
  String? platform;
  String? email; // Email can be null because of apple login;;
  String? snsId;
  DateTime? birthday;
  String? name;
  bool? agreeToGetMail;
  String? gender;
  String? phoneNumber;
  List<Address>? addresses;

  MyUser(
      {this.agreeToGetMail,
      required this.role,
      required this.point,
      required this.id,
      required this.email,
      this.snsId,
      this.birthday,
      required this.platform,
      this.name,
      this.gender,
      this.phoneNumber,
      this.addresses,
      required this.coupons,
      required this.cart});

  MyUser.fromJson(Map<String, dynamic> json) {
    cart = Cart.fromJson(json['cart']);
    role = json['role'];
    point = json['point'];
    isEmailConfirmed = json['isEmailConfirmed'];
    id = json['_id'];
    if (json["snsId"] != null) snsId = json["snsId"];
    if (json["platform"] != null) platform = json["platform"];
    if (json['agreeToGetMail'] != null) agreeToGetMail = json['agreeToGetMail'];
    if (json['gender'] != null) gender = json['gender'];
    if (json['name'] != null) name = json['name'];
    if (json['email'] != null) email = json['email'];
    if (json["birthday"] != null) {
      birthday = DateTime.tryParse(json["birthday"]);
    }
    if (json['phoneNumber'] != null) phoneNumber = json["phoneNumber"];
    if (json['addresses'] != null) {
      addresses = [];
      json['addresses'].forEach((v) {
        addresses!.add(Address.fromJson(v));
      });
    }
    if (json['coupons'] != null) {
      coupons = [];
      json['coupons'].forEach((v) {
        if (!v['used']) coupons.add(Coupon.fromJson(v));
      });
    }
  }

//ToJson must be relevant to the updating. Thus it is worth to secure the data which is not allowed to change.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agreeToGetMail'] = agreeToGetMail ?? false;
    data['isEmailConfirmed'] = isEmailConfirmed;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (gender != null) data['gender'] = gender;
    if (birthday != null) {
      data['birthday'] = birthday!.toIso8601String();
    }
    if (name != null) data['name'] = name;
    data['updatedAt'] = DateTime.now().toIso8601String();
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
