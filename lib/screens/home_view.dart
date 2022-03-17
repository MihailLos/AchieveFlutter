import 'package:achieve_student_flutter/screens/achievements/unreceived_achieve_screen.dart';
import 'package:achieve_student_flutter/screens/home_viewmodel.dart';
import 'package:achieve_student_flutter/screens/profile/profile_screen.dart';
import 'package:achieve_student_flutter/screens/rating/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'achievements/requests_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            body: getViewFromIndex(model.currentIndex),
            bottomNavigationBar: _bottomNavBar(context, model),
          );
        });
  }

  getViewFromIndex(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return ProfileScreen();
      case 1:
        return RatingScreen();
      case 2:
        return UnreceivedAchieveScreen();
      case 3:
        return RequestsScreen();
    }
  }
}

_bottomNavBar(BuildContext context, HomeViewModel model) {
  return BottomNavigationBar(
    currentIndex: model.currentIndex,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    onTap: model.setIndex,
    items: [
      BottomNavigationBarItem(
          icon: Image.asset("assets/images/profile_icon.png"),
          label: "Профиль", activeIcon: Image.asset("assets/images/profile_active.png")),
      BottomNavigationBarItem(
          icon: Image.asset("assets/images/rating_icon.png"), label: "Рейтинг", activeIcon: Image.asset("assets/images/rating_active.png")),
      BottomNavigationBarItem(
          icon: Image.asset("assets/images/achievements_icon.png"),
          label: "Достижения", activeIcon: Image.asset("assets/images/achieve_active.png")),
      BottomNavigationBarItem(
          icon: Image.asset("assets/images/requests_icon.png"), label: "Заявки", activeIcon: Image.asset("assets/images/requests_active.png"))
    ],
  );
}
