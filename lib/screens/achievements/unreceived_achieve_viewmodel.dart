import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/screens/achievements/unreceived_detail_achieve_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../model/unreceived_achievement.dart';
import '../../network_handler.dart';
import 'newachieve_screen.dart';

class UnreceivedAchieveViewModel extends BaseViewModel {
  UnreceivedAchieveViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  List<UnreceivedAchievementModel> unreceivedProfileAchievements = [];
  List<UnreceivedAchievementModel> filteredUnreceivedProfileAchievements = [];
  bool circle = true;

  Future onReady() async {
    fetchUnreceivedAchievements();
    notifyListeners();
  }

  void fetchUnreceivedAchievements([int? statusActiveId]) async {
    List response;
    if (statusActiveId == null) {
      response = await networkHandler.get("/student/achievementsUnreceived/3");
    } else {
      response = await networkHandler
          .get("/student/achievementsUnreceived/$statusActiveId");
    }
    unreceivedProfileAchievements =
        parseUnreceivedAchievements(response);
    filteredUnreceivedProfileAchievements = unreceivedProfileAchievements;
    circle = false;
    notifyListeners();
  }

  List<UnreceivedAchievementModel> parseUnreceivedAchievements(
      List response) {
    return response
        .map<UnreceivedAchievementModel>(
            (json) => UnreceivedAchievementModel.fromJson(json))
        .toList();
  }

  Uint8List getImage(String base64String) {
    var firstDecode = base64Decode(base64String);
    String tempString = String.fromCharCodes(firstDecode).replaceAll("\n", "");
    var secondDecode = base64Decode(tempString);
    return secondDecode;
  }

  goToNewAchievement(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => NewAchieveScreen()));
  }

  goToDetailAchievement(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => UnreceivedDetailAchievementScreen()));
  }
}