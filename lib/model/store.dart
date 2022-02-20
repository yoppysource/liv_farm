class Store {
  late final bool isOpenToday;
  late final String openHourStr;
  late final String closeHourStr;
  late final bool delivery;
  late final bool takeOut;
  late final String name;
  late final String address;
  late final List<int> holidays;
  late final String id;
  late final int maxDistance;
  late final int minAmountForDelivery;
  late final int deliveryFee;
  double? distance;
  bool? availableForDelivery;

  Store(
      {required this.takeOut,
      required this.delivery,
      required this.isOpenToday,
      required this.holidays,
      required this.openHourStr,
      required this.closeHourStr,
      required this.name,
      required this.address,
      required this.maxDistance,
      required this.minAmountForDelivery,
      required this.deliveryFee,
      required this.id});

  Store.fromJson(Map<String, dynamic> json) {
    takeOut = json['takeOut'];
    delivery = json['delivery'];
    holidays = List.castFrom<dynamic, int>(json['holidays']);
    isOpenToday = json['isOpenToday'];
    openHourStr = json['openHourStr'];
    closeHourStr = json['closeHourStr'];
    name = json['name'];
    maxDistance = json['maxDistance'];
    address = json['address'];
    minAmountForDelivery = json['minAmountForDelivery'];
    deliveryFee = json['deliveryFee'];
    id = json['_id'];
    if (json['distance'] != null) {
      distance = json['distance'];
    }
    if (json['availableForDelivery'] != null) {
      availableForDelivery = json['availableForDelivery'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['takeOut'] = takeOut;
    data['delivery'] = delivery;
    data['holidays'] = holidays;
    data['maxDistance'] = maxDistance;
    data['isOpenToday'] = isOpenToday;
    data['openHourStr'] = openHourStr;
    data['closeHourStr'] = closeHourStr;
    data['name'] = name;
    data['address'] = address;
    data['minAmountForDelivery'] = minAmountForDelivery;
    data['deliveryFee'] = deliveryFee;
    data['_id'] = id;
    return data;
  }
}

Map<int, String> weeksDaysInKorean = {
  1: '월요일',
  2: '화요일',
  3: '수요일',
  4: '목요일',
  5: '금요일',
  6: '토요일',
  7: '일요일',
};

extension StoreExtension on Store {
  String getHolidaysInString() {
    List<String?> strList = holidays.map((e) => weeksDaysInKorean[e]).toList();
    if (strList.isEmpty) return '없음';
    String temp = '';
    for (var i = 0; i < strList.length; i++) {
      temp += strList[i]!;
      if (i < strList.length - 1) {
        temp += ', ';
      }
    }
    return temp;
  }

  String? getDistanceString() {
    return distance == null
        ? null
        : (distance! / 1000).toStringAsFixed(1) + 'km';
  }
}
