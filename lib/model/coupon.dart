class Coupon {
  late final String id;
  late final String code;
  late final bool used;
  late final String category;
  late final String? description;
  late final int amount;
  late final DateTime expireDate;

  Coupon(
      {required this.id,
      required this.code,
      required this.used,
      required this.category,
      required this.amount,
      this.description,
      required this.expireDate});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    code = json['code'];
    category = json['category'];
    amount = json['amount'];
    used = json['used'];
    description = json['description'];
    if (json['expireDate'] != null) {
      expireDate = DateTime.parse(json['expireDate']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['code'] = code;
    data['category'] = category;
    data['amount'] = amount;
    data['description'] = description;
    return data;
  }
}
