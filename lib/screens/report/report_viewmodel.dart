import 'dart:convert';

import 'package:achieve_student_flutter/model/report.dart';
import 'package:achieve_student_flutter/network_handler.dart';
import 'package:achieve_student_flutter/screens/report/newreport_screen.dart';
import 'package:achieve_student_flutter/screens/report/report_card.dart';
import 'package:achieve_student_flutter/screens/report/report_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

class ReportViewModel extends BaseViewModel {
  ReportViewModel(BuildContext context);

  var themeReportController = TextEditingController();
  var descriptionReportController = TextEditingController();
  FlutterSecureStorage storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  ReportModel reportModel = ReportModel();
  ReportsCollectionModel? reportsCollectionModel;
  List<ReportModel>? listReports;
  bool circular = true;

  Future onReady() async {
    getReports();
    circular = false;
    notifyListeners();
  }

  goToProfileScreen(context) {
    Navigator.pop(context);
  }

  goToReportsScreen(context) {
    Navigator.pop(context);
  }

  goToNewReportsScreen(context) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => NewReportScreen())).then((value) => refresh());
  }

  goToReportDetailScreen(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => DetailReportScreen()));
  }

  void sendReportAction(context) async {
    var accessToken = await storage.read(key: "token");
    if (themeReportController.text.isNotEmpty &&
        descriptionReportController.text.isNotEmpty) {
      Map<String, String> bodyData = {
        "description": descriptionReportController.text,
        "theme": themeReportController.text
      };
      print(bodyData);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      print(headers);

      var response = await networkHandler.post(
          "/student/newMessageError", headers, bodyData);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ваше обращение успешно отправлено.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка при отправке обращения! (Код ошибки: ${response.statusCode})")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Заполните тему и описание обращения!")));
    }
  }

  void getReports() async {
    var response = await networkHandler.get("/student/messageError");
    reportsCollectionModel = ReportsCollectionModel.fromJson(response);
    listReports = reportsCollectionModel!.list;
    notifyListeners();
  }

  reportsSpace(context) {
    return listReports == null ? Center(child: CircularProgressIndicator()) : Column(
      children:
         listReports!.map((item) => Column(
          children: [
            InkWell(
              onTap: () async {
                await storage.write(key: "report_id", value: item.errorId.toString());
                goToReportDetailScreen(context);
              },
              child: ReportCard(reportModel: item, networkHandler: networkHandler,),
            ),
          ],
        )).toList(),
    );
  }

  Future<void> refresh() async {
    getReports();
  }
}
