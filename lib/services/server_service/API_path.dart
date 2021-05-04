import 'package:flutter/material.dart';
import 'package:liv_farm/secret.dart';

enum Resource {
  users,
  products,
  reviews,
  coupons,
  carts,
  items,
  orders,
  appinfo,
  openingHour
}

class APIPath {
  final Resource resource;

  APIPath({@required this.resource});
  get uri => Uri(
        scheme: scheme,
        host: hostIP,
        port: hostPORT,
        path: basePATH + _resourcePath[this.resource],
      );

  static Map<Resource, String> _resourcePath = {
    Resource.users: "/users",
    Resource.products: "/products",
    Resource.reviews: "/reviews",
    Resource.coupons: "/coupons",
    Resource.carts: "/carts",
    Resource.items: "/items",
    Resource.orders: "/orders",
    Resource.appinfo: "/appinfo",
    Resource.openingHour: "/openingHour",
  };
}
