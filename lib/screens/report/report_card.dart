import 'package:achieve_student_flutter/model/report.dart';
import 'package:achieve_student_flutter/network_handler.dart';
import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({Key? key, this.reportModel, this.networkHandler}) : super(key: key);

  final ReportModel? reportModel;
  final NetworkHandler? networkHandler;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reportModel!.theme.toString() + " " + "(" + reportModel!.statusErrorName.toString() + ")"),
      subtitle: Text(reportModel!.messageErrorDate.toString()),
      isThreeLine: true,
      trailing: Icon(reportModel!.statusErrorName.toString() == "Решено" ? Icons.check : reportModel!.statusErrorName.toString() == "Отклонено" ? Icons.highlight_off : reportModel!.statusErrorName.toString() == "Просмотрено" ? Icons.remove_red_eye : Icons.access_time),
    );
  }
}
