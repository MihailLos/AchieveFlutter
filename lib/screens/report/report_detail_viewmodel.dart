import 'package:achieve_student_flutter/model/detail_report.dart';
import 'package:achieve_student_flutter/network_handler.dart';
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
    detailReportModel = DetailReportModel.fromJson(response);
    DateTime parsedDate = DateTime.parse(detailReportModel.messageErrorDate.toString());
    detailReportModel.messageErrorDate = DateFormat('dd.MM.yyyy').format(parsedDate);
    circular = false;
    notifyListeners();
  }
}