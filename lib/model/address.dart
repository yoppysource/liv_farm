class Address {
  String address;
  String addressDetail;
  String postcode;
  List coordinates;
  Address({this.address, this.addressDetail, this.postcode, this.coordinates});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    addressDetail = json['addressDetail'];
    postcode = json['postcode'];
    if (json['coordinates'] != null) {
    List coordinateList = (json['coordinates'] as List);
    if (coordinateList.isNotEmpty) {
      coordinates = List<double>.from(json["coordinates"].map((x) => x));
    }
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['addressDetail'] = this.addressDetail;
    data['postcode'] = this.postcode;
    if(this.coordinates != null)
    data['coordinates'] = List<dynamic>.from(coordinates.map((x) => x));
    return data;
  }
}
