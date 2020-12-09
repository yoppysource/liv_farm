import 'package:flutter/cupertino.dart';

enum Endpoint {
  login,
  customers,
  carts,
  cartList,
  cartItems,
  purchases,
  products,
  customersSnsId,
  purchaseHistory,
}

class API {
  //TODO static으로 관리하는 access token
  //TODO platform widget list
  //TODO Sever error handling
  //TODO TOKEN shardPreference,
  // 근본은 SQLite로 관리하는게 근본이다(refresh 토큰)
  static String accessToken;
  final Endpoint endpoint;
  final String host = '34.64.245.117';
  API({@required this.endpoint});


  get uri => Uri(
        scheme: 'http',
        host: host,
        port: 3000,
        path: _paths[this.endpoint],
      );

  static Map<Endpoint, String> _paths = {
    Endpoint.login : 'admin/login',
    Endpoint.customers: 'admin/customers',
    Endpoint.carts: 'admin/carts',
    Endpoint.purchaseHistory : 'admin/cart_items_cart',
    Endpoint.cartList: 'admin/cart_lists',
    Endpoint.cartItems: 'admin/cart_items',
    Endpoint.purchases: 'admin/Purchases',
    Endpoint.products: 'admin/products/',
    Endpoint.customersSnsId: 'admin/Customers/sns_id'
  };
}
