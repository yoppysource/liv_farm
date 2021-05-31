import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/server_service/API_path.dart';

class ServerService {
  final APIPath apiPath;
  static String accessToken;

  ServerService({this.apiPath});

  Future<Map<String, dynamic>> postData(
      {Map<String, dynamic> data, path = "/", isForLogin = false}) async {
    try {
      final endpoint = apiPath.uri.toString() + path;
      final http.Response response = await http.post(
        endpoint,
        body: jsonEncode(data),
        headers: {
          'Content-Type': "application/json",
          'Authorization': '${valueForJWT(accessToken) ?? ''}'
        },
      );
      final result = await json.decode(response.body);

      if (!response.statusCode.toString().startsWith("2"))
        throw APIException(
            response.statusCode, result["message"], result["error"]);
      print(result);
      if (isForLogin) return new Map<String, dynamic>.from(result);
      return new Map<String, dynamic>.from(result['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getData({path = "/"}) async {
    try {
      final endpoint = apiPath.uri.toString() + path;
      final response = await http.get(
        endpoint,
        headers: {
          'Content-Type': "application/json",
          'Authorization': '${valueForJWT(accessToken) ?? ''}'
        },
      );
      final result = await json.decode(response.body);
      if (!response.statusCode.toString().startsWith("2"))
        throw APIException(
            response.statusCode, result["message"], result["error"]);
      return new Map<String, dynamic>.from(result['data']);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patchData(
      {Map<String, dynamic> data, path = "/"}) async {
    print(data);
    try {
      final endpoint = apiPath.uri.toString() + path;
      final response = await http.patch(
        endpoint,
        body: jsonEncode(data),
        headers: {
          'Content-Type': "application/json",
          'Authorization': '${valueForJWT(accessToken) ?? ''}'
        },
      );
      final result = await json.decode(response.body);
      if (!response.statusCode.toString().startsWith("2"))
        throw APIException(
            response.statusCode, result["message"], result["error"]);
      print(result);
      return new Map<String, dynamic>.from(result);
    } catch (e) {
      return e;
    }
  }

  Future<void> deleteData({Map<String, dynamic> data, path = "/"}) async {
    try {
      final endpoint = apiPath.uri.toString() + path;
      final response = await http.delete(
        endpoint,
        headers: {
          'Content-Type': "application/json",
          'Authorization': '${valueForJWT(accessToken) ?? ''}'
        },
      );

      if (!response.statusCode.toString().startsWith("2")) {
        final result = await json.decode(response.body);
        throw APIException(
            response.statusCode, result["message"], result["error"]);
      }
    } catch (e) {
      throw e;
    }
  }
}
