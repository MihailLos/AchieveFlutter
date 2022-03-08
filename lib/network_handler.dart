import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseUrl = "http://82.179.1.166:8080";
  var log = Logger();
  FlutterSecureStorage tokenStorage = FlutterSecureStorage();

  Future get(String uri) async {
    String? accessToken = await tokenStorage.read(key: "token");
    uri = formater(uri);
    var response = await http.get(Uri.parse(uri), headers: {
      "Authorization": "Bearer $accessToken"
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    } else if (response.statusCode == 403) {
      // var newAccessToken = await http.get(Uri.parse("http://82.179.1.166:8080/newToken"), headers: {
      //   "Refresh": "Refresh ${tokenStorage.read(key: "refresh_token")}"
      // });
      // tokenStorage.write(key: "token", value: newAccessToken.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> post(String uri, Map<String, String> headers, Map<String, dynamic> body) async {
    uri = formater(uri);
    var response = await http.post(Uri.parse(uri), headers: headers, body: jsonEncode(body));
    return response;
  }

  Future<http.Response> put(String uri, Map<String, String> headers, Map<String, dynamic> body) async {
    uri = formater(uri);
    var response = await http.put(Uri.parse(uri), headers: headers, body: jsonEncode(body));
    return response;
  }

  String formater(String uri) {
    return baseUrl + uri;
  }
}