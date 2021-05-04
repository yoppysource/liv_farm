class Address {
  String address;
  String addressDetail;
  String postcode;
  Address({this.address, this.addressDetail, this.postcode});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    addressDetail = json['addressDetail'];
    postcode = json['postcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['addressDetail'] = this.addressDetail;
    data['postcode'] = this.postcode;
    return data;
  }
}
