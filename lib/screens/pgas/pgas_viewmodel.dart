import 'dart:convert';

import 'package:achieve_student_flutter/model/pgas/short_pgas_request.dart';
import 'package:achieve_student_flutter/screens/pgas/new_pgas_request_screen.dart';
import 'package:achieve_student_flutter/screens/pgas/pgas_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class PgasViewModel extends BaseViewModel {
  PgasViewModel(BuildContext context);

  FlutterSecureStorage storage = FlutterSecureStorage();
  List<ShortPgasRequestModel> pgasList = [];
  bool circle = true;

  Future onReady() async {
    await fetchPgasRequests();
  }

  goToNewPgasRequest(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => NewPgasRequestScreen()));
  }

  goToPgasDetail(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => PgasDetailScreen()));
  }

  fetchPgasRequests() async {
    String? eiosAccessToken = await storage.read(key: "eios_token");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getRequestList"), headers: header);
    if (response.statusCode == 200 || response.statusCode == 201) {
      pgasList = parsePgasRequests(json.decode(response.body)["result"]);
      circle = false;
      notifyListeners();
    } else if (response.statusCode == 401) {
      var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/security/auth/prolong"), headers: header);
      await storage.write(key: "eios_token", value: json.decode(response.body)["accessToken"]);
      print(response.body);
      return fetchPgasRequests();
    }
  }

  List<ShortPgasRequestModel> parsePgasRequests(List response) {
    return response
        .map<ShortPgasRequestModel>((json) => ShortPgasRequestModel.fromJson(json))
        .toList();
  }
}