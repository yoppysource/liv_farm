class Event {
  late final String imageUrl;
  late final String url;

  Event({required this.imageUrl, required this.url});

  Event.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    data['url'] = url;
    return data;
  }
}
