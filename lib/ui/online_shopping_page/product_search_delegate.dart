import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';

class ProductSearch extends SearchDelegate<String> {
  final List<Product> products;

  ProductSearch(this.products);

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
    // TODO: implement buildResults
    throw UnimplementedError();
  }

//TODO: package 이용하기 -> 서버개발자님이 로직을 만들어주기
  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> productSearchList = query.isEmpty
        ? products
        : products.where((product) {
      return product.productName.contains(query);
    }).toList();
    return ListView.builder(
        itemCount: productSearchList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              query = productSearchList[index].productName;
              Navigator.of(context).pop(query);
            },
            leading: Image(image: CachedNetworkImageProvider(productSearchList[index].thumbnailPath),),
            title: Text('${productSearchList[index].productName}'),
          );
        });
  }
}
