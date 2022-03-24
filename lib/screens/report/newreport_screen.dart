import 'package:achieve_student_flutter/screens/report/report_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class NewReportScreenRoute extends MaterialPageRoute {
  NewReportScreenRoute() : super(builder: (context) => const NewReportScreen());
}

class NewReportScreen extends StatelessWidget {
  const NewReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
        viewModelBuilder: () => ReportViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
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
    return ListView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: [
        _mainTitle(),
        SizedBox(
          height: 40,
        ),
        _themeTextField(context, model),
        SizedBox(
          height: 61,
        ),
        _descriptionTextField(context, model),
        SizedBox(
          height: 32,
        ),
        _sendReportButton(context, model)
      ],
    );
  }

  _mainTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        "Создание обращения",
        style: CyrillicFonts.raleway(
            fontSize: 24,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4065D8)),
      ),
    );
  }

  _themeTextField(context, model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 334,
          child: TextField(
              controller: model.themeReportController,
              decoration: InputDecoration(
                hintText: "Тема обращения",
              )),
        ),
      ],
    );
  }

  _descriptionTextField(context, model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 334,
          child: TextField(
              controller: model.descriptionReportController,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: "Описание",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              )),
        ),
      ],
    );
  }

  _sendReportButton(context, model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
      child: Container(
          width: double.maxFinite,
          height: 46,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 6),
                  spreadRadius: 1,
                  blurRadius: 7
              )
            ],
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFBC89),
                Color(0xFFFF9A67)
              ],
            ),
          ),
          child: TextButton(
            onPressed: () async {
              model.sendReportAction(context);
            },
            child: Text(
              "Отправить",
              style: CyrillicFonts.raleway(
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,),
            ),

          )
      ),
    );
  }
}
