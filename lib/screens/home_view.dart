import 'package:achieve_student_flutter/screens/achievements/unreceived_achievements//unreceived_achieve_screen.dart';
import 'package:achieve_student_flutter/screens/home_viewmodel.dart';
import 'package:achieve_student_flutter/screens/profile/profile_screen.dart';
import 'package:achieve_student_flutter/screens/rating/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'achievements/requests/requests_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            body: PageView(
              children: model.tabScreens,
              onPageChanged: model.onPageChanged,
              controller: model.pageController,
            ),
            bottomNavigationBar: _bottomNavBar(context, model),
          );
        });
  }

  getViewFromIndex(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const ProfileScreen();
      case 1:
        return const RatingScreen();
      case 2:
        return const UnreceivedAchieveScreen();
      case 3:
        return const RequestsScreen();
    }
  }
}

_bottomNavBar(BuildContext context, HomeViewModel model) {
  return BottomNavigationBar(
    currentIndex: model.pageIndex,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    onTap: model.onTabTapped,
    items: const [
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: "Профиль"),
      BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard_outlined), label: "Рейтинг"),
      BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events_outlined),
          label: "Достижения"),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings), label: "Заявки"),
    ],
  );
}
