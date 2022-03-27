import 'dart:convert';

import 'package:achieve_student_flutter/model/report/detail_report.dart';
import 'package:achieve_student_flutter/utils/network_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class ReportDetailViewModel extends BaseViewModel {
  ReportDetailViewModel(BuildContext context);
  int? reportId;
  NetworkHandler networkHandler = NetworkHandler();
  DetailReportModel detailReportModel = DetailReportModel();
  bool circular = true;
  FlutterSecureStorage storage = FlutterSecureStorage();


  Future onReady() async {
    getReport();
    notifyListeners();
  }

  goToReportsScreen(context) async {
    Navigator.pop(context);
    await storage.delete(key: "report_id");
  }

  void getReport() async {
    String? reportId = await storage.read(key: "report_id");
    var response = await networkHandler.get("/student/messageError/${int.parse(reportId!)}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      detailReportModel = DetailReportModel.fromJson(json.decode(response.body));
      DateTime parsedDate = DateTime.parse(detailReportModel.messageErrorDate.toString());
      detailReportModel.messageErrorDate = DateFormat('dd.MM.yyyy').format(parsedDate);
      circular = false;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return getReport();
    }
  }
}