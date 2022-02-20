class Review {
  late final DateTime? createdAt;
  late final String review;
  late final double rating;
  late final String id;
  late final String? userName;

  Review(
      {this.createdAt,
      required this.review,
      required this.rating,
      this.userName,
      required this.id});

  Review.fromJson(Map<String, dynamic> json) {
    createdAt = DateTime?.parse(json['createdAt']);
    review = json['review'];
    rating = json['rating'].toDouble();
    id = json['id'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = DateTime.now().toIso8601String();
    data['review'] = review;
    data['rating'] = rating;
    data['userName'] = userName;
    data['id'] = id;
    return data;
  }
}
