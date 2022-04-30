import 'dart:convert';

import 'package:achieve_student_flutter/model/pgas/pgas_detail.dart';
import 'package:achieve_student_flutter/screens/pgas/edit_pgas_request_screen.dart';
import 'package:achieve_student_flutter/screens/pgas/pgas_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class PgasRequestInfoViewModel extends BaseViewModel {
  PgasRequestInfoViewModel(BuildContext context);

  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool circle = true;
  PgasDetailModel? pgasRequest;

  Future onReady() async {
    await fetchDetailPgasRequest();
  }

  goToEditPgasRequestScreen(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditPgasRequestScreen()));
  }

  fetchDetailPgasRequest() async {
    String? eiosAccessToken = await storage.read(key: "eios_token");
    String? pgasRequestId = await storage.read(key: "pgas_id");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    Map<String, dynamic> body = {
      "requestId": pgasRequestId
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getRequestInfo"), headers: header, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      pgasRequest = PgasDetailModel.fromJson(json.decode(response.body)["result"]);
      circle = false;
      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  deletePgasAction(context) async {
    String? eiosAccessToken = await storage.read(key: "eios_token");
    String? pgasRequestId = await storage.read(key: "pgas_id");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    Map<String, dynamic> body = {
      "requestId": pgasRequestId
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/deleteRequest"), headers: header, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const PgasScreen()), (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Заявка успешно удалена.")));
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ошибка при удалении заявки.")));
      print(response.statusCode);
      print(response.body);
    }
  }
}