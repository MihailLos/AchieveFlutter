import 'package:achieve_student_flutter/screens/achievements/achievements_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ReceivedAchieveGridRoute extends MaterialPageRoute {
  ReceivedAchieveGridRoute() : super(builder: (context) => const ReceivedAchieveGrid());
}

class ReceivedAchieveGrid extends StatelessWidget {
  const ReceivedAchieveGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AchievementsViewModel>.reactive(
        viewModelBuilder: () => AchievementsViewModel(context),
        onModelReady: (viewModel) => viewModel.onReadyReceivedAchieveGrid(),
        builder: (context, model, child) {
          return model.receivedProfileAchievementsGrid(context);
        });
  }
}
