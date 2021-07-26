class Event {
  String imageUrl;
  String url;

  Event({this.imageUrl, this.url});

  Event.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['url'] = this.url;
    return data;
  }
}
