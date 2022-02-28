import 'package:achieve_student_flutter/screens/report/report_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class ReportScreenRoute extends MaterialPageRoute {
  ReportScreenRoute() : super(builder: (context) => const ReportScreen());
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
        viewModelBuilder: () => ReportViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return model.circular ? CircularProgressIndicator() : Scaffold(
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
          model.goToProfileScreen(context);
        },
        iconSize: 32,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.black,),
          onPressed: () => model.refresh(),
          iconSize: 32,
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, model) {
    return RefreshIndicator(
      onRefresh: model.refresh,
      child: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          _mainTitle(),
          SizedBox(height: 34,),
          _createReportButton(context, model),
          SizedBox(height: 34,),
          _reportsTitle(),
          SizedBox(height: 31,),
          model.reportsSpace(context)
        ],
      ),
    );
  }

  _mainTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        "Поддержка",
        style: GoogleFonts.montserrat(
          fontSize: 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4065D8)
        ),
      ),
    );
  }

  _createReportButton(context, model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 320,
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
              onPressed: () {
                model.goToNewReportsScreen(context);
              },
              child: Text(
                "Написать в поддержку",
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

  _reportsTitle() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Ваши обращения",
            style: GoogleFonts.montserrat(
                fontSize: 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4065D8)
            ),
          ),
        ],
      ),
    );
  }
}
