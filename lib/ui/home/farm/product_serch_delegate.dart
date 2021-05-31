import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<Product> products;

  ProductSearchDelegate(this.products);

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
    final List<Product> productSearchList = query.isEmpty
        ? products
        : products.where((product) {
            return product.name.contains(query);
          }).toList();
    return ListView.builder(
        itemCount: productSearchList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              query = productSearchList[index].name;
              Navigator.of(context).pop(query);
            },
            leading: Image(
              image: CachedNetworkImageProvider(
                  productSearchList[index].thumbnailPath),
            ),
            title: Text(
              '${productSearchList[index].name}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        });
  }
}
