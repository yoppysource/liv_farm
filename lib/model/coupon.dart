class Coupon {
  String id;
  String code;
  bool used;
  String category;
  String description;
  int amount;
  DateTime expireDate;

  Coupon(
      {this.id,
      this.code,
      this.used,
      this.category,
      this.amount,
      this.description,
      this.expireDate});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    code = json['code'];
    category = json['category'];
    amount = json['amount'];
    used = json['used'];
    description = json['description'];
    if (json['expireDate'] != null)
      expireDate = DateTime.parse(json['expireDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['code'] = this.code;
    data['category'] = this.category;
    data['amount'] = this.amount;
    data['description'] = this.description;
    return data;
  }
}
