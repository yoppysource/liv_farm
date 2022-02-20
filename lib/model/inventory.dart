import 'package:liv_farm/model/option_group.dart';
import 'package:liv_farm/model/product.dart';

class Inventory {
  late final int inventory;
  late final int rank;
  late final bool isOnShelf;
  late final bool hidden;
  late final String store;
  late final Product product;
  late final String id;
  late final List<OptionGroup> optionGroups;
  late final bool recommended;

  Inventory(
      {required this.inventory,
      required this.rank,
      required this.isOnShelf,
      required this.hidden,
      required this.store,
      required this.product,
      required this.id,
      required this.optionGroups,
      required this.recommended});

  Inventory.fromJson(Map<String, dynamic> json) {
    inventory = json['inventory'];
    rank = json['rank'];
    isOnShelf = json['isOnShelf'];
    hidden = json['hidden'];
    store = json['store'];
    product = Product.fromJson(json['product']);
    optionGroups = [];
    json['optionGroups'].forEach((v) {
      optionGroups.add(OptionGroup.fromJson(v));
    });
    id = json['id'];
    recommended = json['recommended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inventory'] = inventory;
    data['rank'] = rank;
    data['isOnShelf'] = isOnShelf;
    data['hidden'] = hidden;
    data['store'] = store;
    data['product'] = product.toJson();
    data['id'] = id;
    data['optionGroups'] = optionGroups.map((v) => v.toJson()).toList();
    data['recommended'] = recommended;
    return data;
  }
}
