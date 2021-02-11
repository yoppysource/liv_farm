class CustomerLog {
  final double lat;
  final double lng;
  final String loginOS;
  final String appVersion;
  final int customerId;

  CustomerLog({this.lat, this.lng, this.loginOS, this.appVersion, this.customerId});

  Map<String, dynamic>toJson() {
    return <String, dynamic>{
      'customer_id' : this.customerId,
      'lat' : this.lat,
      'lng' : this.lng,
      'loginos' : this.loginOS,
      'appversion' : this.appVersion,
    };
  }

}