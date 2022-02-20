import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/server_service/api_exception.dart';
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
  inventories,
}

enum HttpMethod { get, post, patch, delete }

class ClientService {
  static String? accessToken;
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
    Resource.inventories: "/inventories",
  };

  Uri getUri({required Resource resource, String path = '/'}) => Uri(
        scheme: scheme,
        host: hostIP,
        port: hostPORT,
        path: "$basePATH${resourcePath[resource]}$path",
      );

  Future<T> sendRequest<T>(
      {required HttpMethod method,
      required Resource resource,
      String endPath = '',
      Map? data = const {},
      bool getAllData = false}) async {
    try {
      final Uri endpoint = getUri(resource: resource, path: endPath);
      Map<String, String> header = {
        'Content-Type': "application/json",
      };
      if (accessToken != null) {
        header['Authorization'] = valueForJWT(accessToken!);
      }
      http.Response response;
      switch (method) {
        case HttpMethod.get:
          response = await http.get(endpoint, headers: header);
          break;
        case HttpMethod.post:
          response = await http.post(endpoint,
              body: jsonEncode(data), headers: header);
          break;
        case HttpMethod.delete:
          response = await http.delete(endpoint,
              body: jsonEncode(data), headers: header);
          break;
        case HttpMethod.patch:
          response = await http.patch(endpoint,
              body: jsonEncode(data), headers: header);
          break;
        default:
          throw Exception("the http method should be defined!");
      }
      final result = await jsonDecode(response.body) as Map<String, dynamic>;
      if (!response.statusCode.toString().startsWith("2")) {
        throw APIException(response.statusCode, result["message"]);
      }
      if (method == HttpMethod.delete) return result as T;
      // this is some case for get full body i.e JWT token.
      if (getAllData) return result as T;
      return result['data']['data'] as T;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Future<T> postData<T>(
  //     {required Resource resource,
  //     path = "/",
  //     isOtherDataNeed = false,
  //     Map<String, dynamic> data}) async {
  //   try {
  //     final Uri endpoint = getUri(resource: resource, path: path);
  //     final http.Response response = await http.post(
  //       endpoint,
  //       body: jsonEncode(data),
  //       headers: {
  //         'Content-Type': "application/json",
  //         'Authorization': valueForJWT(accessToken)
  //       },
  //     );

  //     final result = await jsonDecode(response.body) as Map<String, dynamic>;
  //     if (!response.statusCode.toString().startsWith("2")) {
  //       throw APIException(response.statusCode, result["message"]);
  //     }
  //     if (isOtherDataNeed) return result as T;
  //     return result['data']['data'] as T;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<T> getData<T>({Resource resource, path = "/"}) async {
  //   try {
  //     print(path.toString());
  //     final Uri endpoint = getUri(resource: resource, path: path);

  //     final response = await http.get(
  //       endpoint,
  //       headers: {
  //         'Content-Type': "application/json",
  //         'Authorization': valueForJWT(accessToken)
  //       },
  //     );
  //     final result = await json.decode(response.body);
  //     if (!response.statusCode.toString().startsWith("2")) {
  //       throw APIException(response.statusCode, result["message"]);
  //     }
  //     return result['data']['data'];
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     debugPrint(e.message);
  //     rethrow;
  //   }
  // }

  // Future<T> patchData<T>(
  //     {Resource resource, path = "/", Map<String, dynamic> data}) async {
  //   try {
  //     final Uri endpoint = getUri(resource: resource, path: path);
  //     final response = await http.patch(
  //       endpoint,
  //       body: jsonEncode(data),
  //       headers: {
  //         'Content-Type': "application/json",
  //         'Authorization': valueForJWT(accessToken)
  //       },
  //     );
  //     final result = await json.decode(response.body);
  //     if (!response.statusCode.toString().startsWith("2")) {
  //       throw APIException(response.statusCode, result["message"]);
  //     }
  //     return result['data']['data'] as T;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<void> deleteData(
  //     {Resource resource,
  //     path = "/",
  //     Map<String, dynamic> data = const {}}) async {
  //   try {
  //     final Uri endpoint = getUri(resource: resource, path: path);
  //     final response = await http.delete(
  //       endpoint,
  //       headers: {
  //         'Content-Type': "application/json",
  //         'Authorization': valueForJWT(accessToken)
  //       },
  //     );
  //     if (!response.statusCode.toString().startsWith("2")) {
  //       throw APIException(response.statusCode, "오류가 발생했습니다");
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
