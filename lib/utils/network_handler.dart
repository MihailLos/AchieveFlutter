import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseUrl = "http://82.179.1.166:8080";
  var log = Logger();
  FlutterSecureStorage tokenStorage = const FlutterSecureStorage();

  Future get(String uri, [Map<String, String>? customHeaders]) async {
    http.Response response;
    String? accessToken = await tokenStorage.read(key: "token");
    uri = formater(uri);

    if (customHeaders == null) {
      response = await http.get(Uri.parse(uri), headers: {
        "Authorization": "Bearer $accessToken"
      });
    } else {
      response = await http.get(Uri.parse(uri), headers: customHeaders);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
    } else {
      log.i(response.body);
      log.i(response.statusCode);
    }
    return response;
  }

  Future<http.Response> post(String uri, Map<String, String>? headers, Map<String, dynamic>? body) async {
    uri = formater(uri);
    var response = await http.post(Uri.parse(uri), headers: headers, body: jsonEncode(body));
    return response;
  }

  Future<http.Response> put(String uri, Map<String, String>? headers, Map<String, dynamic>? body) async {
    uri = formater(uri);
    var response = await http.put(Uri.parse(uri), headers: headers, body: jsonEncode(body));
    return response;
  }

  String formater(String uri) {
    return baseUrl + uri;
  }
}