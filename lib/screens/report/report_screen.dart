import 'package:achieve_student_flutter/screens/report/report_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
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
          return model.circular ? const CircularProgressIndicator() : Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, ReportViewModel model) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () async {
          model.goToProfileScreen(context);
        },
        iconSize: 32,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, ReportViewModel model) {
    return RefreshIndicator(
      onRefresh: model.refresh,
      child: ListView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          _mainTitle(),
          const SizedBox(height: 34,),
          _createReportButton(context, model),
          const SizedBox(height: 34,),
          _reportsTitle(),
          const SizedBox(height: 31,),
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
        style: CyrillicFonts.raleway(
          fontSize: 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4065D8)
        ),
      ),
    );
  }

  _createReportButton(context, model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
      child: Container(
          width: double.maxFinite,
          height: 46,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 6),
                  spreadRadius: 1,
                  blurRadius: 7
              )
            ],
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
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
              model.goToNewReportsScreen(context);
            },
            child: Text(
              "Написать в поддержку",
              style: CyrillicFonts.robotoMono(
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,),
            ),

          )
      ),
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
            style: CyrillicFonts.raleway(
                fontSize: 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4065D8)
            ),
          ),
        ],
      ),
    );
  }
}
