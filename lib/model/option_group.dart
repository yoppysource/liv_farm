import 'package:liv_farm/secret.dart';

class OptionGroup {
  OptionGroup({
    required this.id,
    required this.name,
    required this.mandatory,
    required this.multiSelectable,
    required this.options,
  });
  late final String id;
  late final String name;
  late final bool mandatory;
  late final bool multiSelectable;
  late final List<Option> options;

  OptionGroup.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    mandatory = json['mandatory'];
    multiSelectable = json['multiSelectable'];
    options =
        List.from(json['options']).map((e) => Option.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    _data['mandatory'] = mandatory;
    _data['multiSelectable'] = multiSelectable;
    _data['options'] = options.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Option {
  Option({
    required this.price,
    required this.avaliable,
    required this.id,
    required this.name,
    required this.imagePath,
  });
  late final int price;
  late final bool avaliable;
  late final String id;
  late final String name;
  late final String imagePath;

  Option.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    avaliable = json['avaliable'];
    id = json['_id'];
    name = json['name'];
    imagePath = Uri(scheme: scheme, port: hostPORT, host: hostIP).toString() +
        json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['price'] = price;
    _data['avaliable'] = avaliable;
    _data['_id'] = id;
    _data['name'] = name;
    _data['imagePath'] = imagePath;
    return _data;
  }
}
