class Review {
  DateTime createdAt;
  String review;
  double rating;
  String id;
  String userName;

  Review({this.createdAt, this.review, this.rating, this.userName, this.id});

  Review.fromJson(Map<String, dynamic> json) {
    createdAt = DateTime?.parse(json['createdAt']) ?? null;
    review = json['review'];
    rating = json['rating'].toDouble();
    id = json['id'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = DateTime.now().toIso8601String();
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['userName'] = this.userName;
    data['id'] = this.id;
    return data;
  }
}
