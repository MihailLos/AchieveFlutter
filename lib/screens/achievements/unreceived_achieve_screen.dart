import 'package:achieve_student_flutter/screens/achievements/achievements_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class UnreceivedAchieveScreenRoute extends MaterialPageRoute {
  UnreceivedAchieveScreenRoute() : super(builder: (context) => const UnreceivedAchieveScreen());
}

class UnreceivedAchieveScreen extends StatelessWidget {
  const UnreceivedAchieveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AchievementsViewModel>.reactive(
        viewModelBuilder: () => AchievementsViewModel(context),
        onModelReady: (viewModel) => viewModel.onReadyUnreceived(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, model) {
    return AppBar(
      title: Text("Неполученные Достижения",
          style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4065D8))),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.add_box), color: Color(0xFF4065D8), iconSize: 32,)
      ],
      // bottom:
    );
  }

  _body(context, model) {
    return Column(
      children: [
        _buttonsTab(context, model),
        model.unreceivedAchievementsList(context)
      ],
    );
  }

  _buttonsTab(context, model) {
    return Container(
      child: Row (
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchUnreceivedAchievements();
                },
                child: Text("Активные")
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchUnreceivedAchievements(2);
                },
                child: Text("Неактивные")
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchUnreceivedAchievements(4);
                },
                child: Text("Устаревшие")
            ),
          )
        ],
      ),
    );
  }
}
