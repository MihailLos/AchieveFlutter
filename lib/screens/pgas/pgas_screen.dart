import 'package:achieve_student_flutter/screens/pgas/pgas_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class PgasScreenRoute extends MaterialPageRoute {
  PgasScreenRoute() : super(builder: (context) => const PgasScreen());
}

class PgasScreen extends StatelessWidget {
  const PgasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasViewModel>.reactive(
        viewModelBuilder: () => PgasViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, PgasViewModel model) {
    return AppBar(
      title: Text("Заявки ПГАС",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4065D8))),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, PgasViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          _createRequestButton(context, model),
          SizedBox(height: 12,),
          _requestsTitle(context, model)
        ],
      ),
    );
  }

  _createRequestButton(context, PgasViewModel model) {
    return Container(
        width: double.maxFinite,
        height: 46,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey,
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 4)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
          },
          child: Text(
            "Создать заявку",
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
    );
  }

  _requestsTitle(context, PgasViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Мои заявки",
            style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4065D8)
            )
        )
      ],
    );
  }
}
