import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:http/http.dart' as http;

enum Resource {
  users,
  products,
  reviews,
  coupons,
  carts,
  items,
  orders,
  events,
  appinfo,
  stores,
  openingHour,
  auth,
}

class ServerService {
  static String accessToken = '';
  final Map<Resource, String> resourcePath = {
    Resource.users: "/users",
    Resource.auth: "/auth",
    Resource.products: "/products",
    Resource.reviews: "/reviews",
    Resource.coupons: "/coupons",
    Resource.carts: "/carts",
    Resource.events: "/events",
    Resource.stores: '/stores',
    Resource.orders: "/orders",
    Resource.appinfo: "/appInfo",
    Resource.openingHour: "/openingHour",
  };

  Uri getUri({Resource resource, String path = '/'}) => Uri(
        scheme: scheme,
        host: hostIP,
        // port: hostPORT,
        path: "$basePATH${this.resourcePath[resource]}$path",
      );

  Future<T> postData<T>(
      {Resource resource,
      path = "/",
      isOtherDataNeed = false,
      Map<String, dynamic> data}) async {
    try {
      final Uri endpoint = getUri(resource: resource, path: path);
      final http.Response response = await http.post(
        endpoint,
        body: jsonEncode(data),
        headers: {
          'Content-Type': "application/json",
          'Authorization': '${valueForJWT(accessToken)}'
        },
      );
    
      final result = await jsonDecode(response.body) as Map<String, dynamic>;
      if (!response.statusCode.toString().startsWith("2"))
        throw APIException(response.statusCode, result["message"]);
      if (isOtherDataNeed) return result as T;
      return result['data']['data'] as T;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<T> getData<T>({Resource resource, path = "/"}) async {
    try {
      final Uri endpoint = getUri(resource: resource, path: path);
      final response = await http.get(
        endpoint,
        headers: {
          'Content-Type': "application/json",
          'Authorization': '${valueForJWT(accessToken)}'
        },
      );
      final result = await json.decode(response.body);
      if (!response.statusCode.toString().startsWith("2"))
        throw APIException(response.statusCode, result["message"]);
        return result['data']['data'];      
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<T> patchData<T>(
      {Resource resource, path = "/", Map<String, dynamic> data}) async {
    try {
      final Uri endpoint = getUri(resource: resource, path: path);
      final response = await http.patch(
        endpoint,
        body: jsonEncode(data),
        headers: {
          'Content-Type': "application/json",
          'Authorization': '${valueForJWT(accessToken)}'
        },
      );
      final result = await json.decode(response.body);
      if (!response.statusCode.toString().startsWith("2"))
        throw APIException(response.statusCode, result["message"]);
      return result['data']['data'] as T;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteData(
      {Resource resource,
      path = "/",
      Map<String, dynamic> data = const {}}) async {
    try {
      final Uri endpoint = getUri(resource: resource, path: path);
      final response = await http.delete(
        endpoint,
        headers: {
          'Content-Type': "application/json",
          'Authorization': '${valueForJWT(accessToken)}'
        },
      );
      if (!response.statusCode.toString().startsWith("2"))
        throw APIException(response.statusCode, "오류가 발생했습니다");
    } catch (e) {
      rethrow;
    }
  }
}
