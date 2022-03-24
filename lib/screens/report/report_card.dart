import 'package:achieve_student_flutter/model/report.dart';
import 'package:achieve_student_flutter/network_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({Key? key, this.reportModel, this.networkHandler}) : super(key: key);

  final ReportModel? reportModel;
  final NetworkHandler? networkHandler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reportModel!.theme.toString(),
                style: CyrillicFonts.raleway(
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
              ),
              Text(
                  reportModel!.statusErrorName.toString(),
                  style: CyrillicFonts.openSans(
                    fontStyle: FontStyle.normal,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)
              ),
              Text(
                  reportModel!.messageErrorDate.toString(),
                  style: CyrillicFonts.openSans(
                      fontStyle: FontStyle.normal,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54)
              )
            ],
          ),
          reportModel!.statusErrorName.toString() == "Решено" ?
          Icon(Icons.check, color: Colors.green, size: 36,) :
          reportModel!.statusErrorName.toString() == "Отклонено" ?
          Icon(Icons.close, color: Colors.red, size: 36,) :
          reportModel!.statusErrorName.toString() == "Просмотрено" ?
          Icon(Icons.visibility, color: Colors.blueAccent, size: 36,) :
          Icon(Icons.watch_later_outlined, color: Colors.black, size: 36,)
        ],
      ),
    );
  }
}
