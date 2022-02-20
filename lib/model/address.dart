class Address {
  late final String address;
  late final String? addressDetail;
  late final String postcode;
  List<double>? coordinates;
  Address(
      {required this.address,
      this.addressDetail,
      required this.postcode,
      this.coordinates});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['addressDetail'] = addressDetail;
    data['postcode'] = postcode;
    if (coordinates != null) {
      data['coordinates'] = List<dynamic>.from(coordinates!.map((x) => x));
    }
    return data;
  }
}
