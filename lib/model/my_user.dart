import 'package:liv_farm/constant.dart';

class MyUser {
  final int id;
  final String snsId;
  String name;
  String email;
  String birthday;
  String postCode;
  String address;
  String gender;
  String addressDetail;
  String phoneNumber;
  final String platform;
  final String updatedAt;

  MyUser(
      {this.id,
      this.snsId,
      this.name,
      this.email,
      this.birthday,
      this.postCode,
      this.gender,
      this.address,
      this.addressDetail,
      this.phoneNumber,
      this.platform,
      this.updatedAt,
 });

  factory MyUser.fromJson({Map<String, dynamic> data}) {
    if (data == null) {
      return null;
    } else {
      return MyUser(
          id: data[KEY_customer_uid],
          snsId: data[KEY_customer_snsId].toString() ?? '',
          name: data[KEY_customer_name] ?? '',
          email: data[KEY_customer_email] ?? '',
          birthday: data[KEY_customer_birth] ?? '',
          postCode: data[KEY_customer_postcode] ?? '',
          address: data[KEY_customer_address] ?? '',
          addressDetail: data[KEY_customer_detailedAddress] ?? '',
          phoneNumber: data[KEY_customer_phone] ?? '',
          platform: data[KEY_customer_platform],
          gender: data[KEY_customer_gender] ?? '',
          updatedAt: data[KEY_customer_updatedAt] ?? '',
      );
    }
  }

  //어플 내에서의 가변값을 지정해야된
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      KEY_customer_uid: this.id,
      KEY_customer_snsId: this.snsId,
      KEY_customer_name: this.name ?? '',
      KEY_customer_gender: this.gender ?? '',
      KEY_customer_email: this.email ?? '',
      KEY_customer_birth: this.birthday,
      KEY_customer_postcode: this.postCode ?? '',
      KEY_customer_address: this.address ?? '',
      KEY_customer_detailedAddress: this.addressDetail ?? '',
      KEY_customer_phone: this.phoneNumber ?? '',
      KEY_customer_updatedAt: this.updatedAt ?? DateTime.now().toIso8601String(),
    };
  }
}
