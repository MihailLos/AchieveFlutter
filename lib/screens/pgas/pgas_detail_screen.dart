import 'package:achieve_student_flutter/screens/pgas/pgas_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class PgasDetailScreenRoute extends MaterialPageRoute {
  PgasDetailScreenRoute() : super(builder: (context) => const PgasDetailScreen());
}

class PgasDetailScreen extends StatelessWidget {
  const PgasDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasDetailViewModel>.reactive(
        viewModelBuilder: () => PgasDetailViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, PgasDetailViewModel model) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () async {
          Navigator.pop(context);
        },
        iconSize: 32,
      ),
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () {
              model.goToEditPgasRequestScreen(context);
            },
            icon: Icon(Icons.edit_outlined, color: Color(0xFF5878DD), size: 32,)
        ),
        IconButton(
            onPressed: () {
              model.goToPgasRequestInfoScreen(context);
            },
            icon: Icon(Icons.info_outline, color: Color(0xFF5878DD), size: 32,)
        )
      ],
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, PgasDetailViewModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _title(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _title(context) {
    return Text("Прикрепить достижения",
        style: CyrillicFonts.raleway(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF4065D8)
        )
    );
  }
}
