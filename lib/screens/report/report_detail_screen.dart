import 'package:achieve_student_flutter/model/report.dart';
import 'package:achieve_student_flutter/screens/report/report_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Text(
      "Обращение №${model.detailReportModel.errorId} от ${model.detailReportModel.messageErrorDate}",
      style: GoogleFonts.montserrat(
          fontSize: 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4065D8)),
    );
  }

  _theme(context, model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Тема обращения:",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF9966)),
        ),
        SizedBox(height: 8,),
        Text(
          "${model.detailReportModel.theme}",
          style: GoogleFonts.montserrat(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )
      ],
    );
  }

  _description(context, model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Описание обращения:",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF9966)),
        ),
        SizedBox(height: 8,),
        Text(
          "${model.detailReportModel.description}",
          style: GoogleFonts.montserrat(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )
      ],
    );
  }

  _statusError(context, model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Статус проверки обращения:",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF9966)),
        ),
        SizedBox(height: 8,),
        Row(
          children: [
            Icon(model.detailReportModel.comment == "Решено" ? Icons.check : model.detailReportModel.comment == "Отклонено" ? Icons.highlight_off : model.detailReportModel.comment == "Просмотрено" ? Icons.remove_red_eye : Icons.access_time),
            Text(
              "${model.detailReportModel.statusErrorName}",
              style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        )
      ],
    );
  }

  _adminComment(context, model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Комментарий администратора:",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF9966)),
        ),
        SizedBox(height: 8,),
        Text(model.detailReportModel.comment != null ? "${model.detailReportModel.comment}" : "",
          style: GoogleFonts.montserrat(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )
      ],
    );
  }
}
