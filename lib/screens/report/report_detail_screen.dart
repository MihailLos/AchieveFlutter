import 'package:achieve_student_flutter/model/report.dart';
import 'package:achieve_student_flutter/screens/report/report_detail_viewmodel.dart';
import 'package:achieve_student_flutter/screens/report/report_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class DetailReportScreenRoute extends MaterialPageRoute {
  DetailReportScreenRoute() : super(builder: (context) => const DetailReportScreen());
}

class DetailReportScreen extends StatelessWidget {
  const DetailReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportDetailViewModel>.reactive(
        viewModelBuilder: () => ReportDetailViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return model.circular ? Center(child: CircularProgressIndicator()) : Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, model) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () async {
          model.goToReportsScreen(context);
        },
        iconSize: 32,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _mainTitle(context, model),
          SizedBox(height: 16,),
          _theme(context, model),
          SizedBox(height: 16,),
          _description(context, model),
          SizedBox(height: 16,),
          _statusError(context, model),
          SizedBox(height: 16,),
          _adminComment(context, model)
        ],
      ),
    );
  }

  _mainTitle(context, model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Text(
        "Поддержка",
        style: CyrillicFonts.raleway(
            fontSize: 24,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4065D8)),
      ),
    );
  }

  _theme(context, model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Тема",
            style: CyrillicFonts.raleway(
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          Text(
            "${model.detailReportModel.theme}",
            style: CyrillicFonts.openSans(
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          )
        ],
      ),
    );
  }

  _description(context, model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Описание обращения:",
            style: CyrillicFonts.raleway(
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          Text(
            "${model.detailReportModel.description}",
            style: CyrillicFonts.openSans(
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          )
        ],
      ),
    );
  }

  _statusError(context, ReportDetailViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Статус:",
            style: CyrillicFonts.raleway(
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          SizedBox(height: 8,),
          Row(
            children: [
              model.detailReportModel.statusErrorName.toString() == "Решено" ?
              Icon(Icons.check, color: Colors.green, size: 36,) :
              model.detailReportModel.statusErrorName.toString() == "Отклонено" ?
              Icon(Icons.close, color: Colors.red, size: 36,) :
              model.detailReportModel.statusErrorName.toString() == "Просмотрено" ?
              Icon(Icons.visibility, color: Colors.blueAccent, size: 36,) :
              Icon(Icons.watch_later_outlined, color: Colors.black, size: 36,),
              SizedBox(width: 7,),
              Text(
                "${model.detailReportModel.statusErrorName}",
                style: CyrillicFonts.openSans(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          )
        ],
      ),
    );
  }

  _adminComment(context, model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Комментарий",
            style: CyrillicFonts.raleway(
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          SizedBox(height: 8,),
          Text(model.detailReportModel.comment != null ? "${model.detailReportModel.comment}" : "",
            style: CyrillicFonts.openSans(
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          )
        ],
      ),
    );
  }
}
