import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/inventory.dart';
class ProductSearchDelegate extends SearchDelegate<String> {
  final List<Inventory> inventories;

  ProductSearchDelegate(this.inventories);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Inventory> productSearchList = query.isEmpty
        ? inventories
        : inventories.where((inventory) {
            return inventory.product.name.contains(query);
          }).toList();
    return ListView.builder(
        itemCount: productSearchList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              query = productSearchList[index].product.name;
              Navigator.of(context).pop(query);
            },
            leading: Image(
              image: CachedNetworkImageProvider(
                  productSearchList[index].product.thumbnailPath),
            ),
            title: Text(
              '${productSearchList[index].product.name}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        });
  }
}
