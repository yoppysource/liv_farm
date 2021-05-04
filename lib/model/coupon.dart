class Coupon {
  String type;
  String id;
  String code;
  bool used;
  String category;
  int amount;
  String expireDate;

  Coupon(
      {this.type,
      this.id,
      this.code,
      this.used,
      this.category,
      this.amount,
      this.expireDate});

  Coupon.fromJson(Map<String, dynamic> json) {
    if (!json['used']) {
      type = json['type'];
      id = json['_id'];
      code = json['code'];
      category = json['category'];
      amount = json['amount'];
      expireDate = json['expireDate'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['used'] = this.used;
    return data;
  }
}
