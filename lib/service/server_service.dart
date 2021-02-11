import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/service/api.dart';

class ServerService {
  final API api;
  dynamic mapForException = {MSG: MSG_fail};

    ServerService({this.api});

  Future<T> postData<T>(
      {@required data, String params1 = '', String params2 = ''}) async {
    try {
      final http.Response response = await http.post(
        '${api.uri}$params1$params2',
        body: jsonEncode(data),
        headers: {
          'Content-Type': "application/json",
          'customer_t': '${API.accessToken ?? ''}'
        },
      );
      final result = await json.decode(response.body);
      print(result.toString());
      return result;
    } catch (e) {
      return mapForException;
    }
  }

  Future<T> getData<T>({String params1 = '', String params2 = ''}) async {
    try {
      print(api.uri);
      final response = await http.get(
        '${api.uri}$params1$params2',
        headers: {
          'Content-Type': "application/json",
          'customer_t': API.accessToken ?? '',
          // '${API.accessToken ?? ''}',
        },
      );
      final result = await json.decode(response.body);
      return result;
    } catch (e) {
      return mapForException;
    }
  }
}
