import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'achievements_viewmodel.dart';

class RequestsScreenRoute extends MaterialPageRoute {
  RequestsScreenRoute() : super(builder: (context) => const RequestsScreen());
}

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AchievementsViewModel>.reactive(
        viewModelBuilder: () => AchievementsViewModel(context),
        onModelReady: (viewModel) => viewModel.onReadyRequests(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, model) {
    return AppBar(
      title: Text("Мои Заявки",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4065D8))),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(onPressed: () {
          faqDialog(context);
        }, icon: Icon(Icons.info_outline), color: Color(0xFF4065D8), iconSize: 32,)
      ],
      // bottom:
    );
  }

  _body(context, model) {
    return Column(
      children: [
        _buttonsTab(context, model),
        model.isProof ? model.proofAchievementsList(context) : model.createdAchievementsList(context)
      ],
    );
  }

  _buttonsTab(context, model) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD3D3D3),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row (
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    model.proofAchieveButtonActive(context);
                    model.changeRequestsProofAchievements(context);
                  },
                  child: Text("Подтверждение", style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  primary: model.isProofAchieveButtonTapped ? Colors.white : Colors.transparent,
                  elevation: 0
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    model.createdAchieveButtonActive(context);
                    model.changeRequestsCreatedAchievements(context);
                  },
                  child: Text("Создание", style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                    primary: model.isCreatedAchieveButtonTapped ? Colors.white : Colors.transparent,
                  elevation: 0
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  faqDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Подтверждение - вкладка предназначена для отображения заявок на получение достижений.\nСоздание - вкладка предназначена для отображения заявок на создание достижений."
            ),
          );
        }
    );
  }
}
