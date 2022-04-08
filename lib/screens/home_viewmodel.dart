import 'package:achieve_student_flutter/screens/profile/profile_screen.dart';
import 'package:achieve_student_flutter/screens/rating/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'achievements/requests/requests_screen.dart';
import 'achievements/unreceived_achievements/unreceived_achieve_screen.dart';

class HomeViewModel extends BaseViewModel {

  int pageIndex = 0;
  PageController? pageController;

  List<Widget> tabScreens = [
    ProfileScreen(),
    RatingScreen(),
    UnreceivedAchieveScreen(),
    RequestsScreen()
  ];

  Future onReady() async {
    pageController = PageController(initialPage: pageIndex);
    notifyListeners();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    pageIndex = page;
    notifyListeners();
  }

  void onTabTapped(int index) {
    pageController!.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}