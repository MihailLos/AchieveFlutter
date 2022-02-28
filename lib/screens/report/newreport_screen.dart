import 'package:achieve_student_flutter/screens/report/report_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        style: GoogleFonts.montserrat(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 334,
            height: 46,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color(0xffbfbfbf),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: Offset(0, 4)),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                model.sendReportAction(context);
              },
              child: Text(
                "Отправить",
                style: TextStyle(
                    fontFamily: "Montseratt",
                    fontStyle: FontStyle.normal,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                primary: Color(0xFFFF9966),
              ),
            )
        ),
      ],
    );
  }
}
