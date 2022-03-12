import 'package:achieve_student_flutter/screens/achievements/achievements_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreatedAchieveGridRoute extends MaterialPageRoute {
  CreatedAchieveGridRoute() : super(builder: (context) => const CreatedAchieveGrid());
}

class CreatedAchieveGrid extends StatelessWidget {
  const CreatedAchieveGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AchievementsViewModel>.reactive(
        viewModelBuilder: () => AchievementsViewModel(context),
        onModelReady: (viewModel) => viewModel.onReadyCreatedAchieveGrid(),
        builder: (context, model, child) {
          return model.createdProfileAchievementsGrid(context);
        });
  }
}
