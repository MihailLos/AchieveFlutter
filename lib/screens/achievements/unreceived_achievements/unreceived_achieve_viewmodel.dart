import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/screens/achievements/unreceived_achievements/unreceived_detail_achieve_screen.dart';
import 'package:achieve_student_flutter/utils/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../../model/achievement/unreceived_achievement/unreceived_achievement.dart';
import '../../../utils/network_handler.dart';
import '../new_achievement/newachieve_screen.dart';

class UnreceivedAchieveViewModel extends BaseViewModel {
  UnreceivedAchieveViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  List<UnreceivedAchievementModel> unreceivedProfileAchievements = [];
  List<UnreceivedAchievementModel> filteredUnreceivedProfileAchievements = [];
  bool circle = true;
  Parser parser = Parser();
  List<bool> isSelectedButton = [true, false, false];

  Future onReady() async {
    fetchUnreceivedAchievements();
    notifyListeners();
  }

  fetchUnreceivedAchievements([int? statusActiveId]) async {
    var response;
    circle = true;
    if (statusActiveId == null) {
      response = await networkHandler.get("/student/achievementsUnreceived/3");
      if (response.statusCode == 200 || response.statusCode == 200) {
        unreceivedProfileAchievements =
            parser.parseUnreceivedAchievements(json.decode(response.body));
        filteredUnreceivedProfileAchievements = unreceivedProfileAchievements;
        circle = false;
        notifyListeners();
      } else if (response.statusCode == 403) {
        var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
        await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
        return fetchUnreceivedAchievements();
      }
    } else {
      response = await networkHandler
          .get("/student/achievementsUnreceived/$statusActiveId");
      if (response.statusCode == 200 || response.statusCode == 200) {
        unreceivedProfileAchievements =
            parser.parseUnreceivedAchievements(json.decode(response.body));
        filteredUnreceivedProfileAchievements = unreceivedProfileAchievements;
        circle = false;
        notifyListeners();
      } else if (response.statusCode == 403) {
        var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
        await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
        return fetchUnreceivedAchievements(statusActiveId);
      }
    }
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

  onChangeToggle(int newIndex) {
    for (int index = 0; index < isSelectedButton.length; index++) {
      if (index == newIndex) {
        if (isSelectedButton[index] != true) {
          isSelectedButton[index] = true;
          if (newIndex == 0) {
            fetchUnreceivedAchievements();
            notifyListeners();
          } else if (newIndex == 1) {
            fetchUnreceivedAchievements(2);
            notifyListeners();
          } else {
            fetchUnreceivedAchievements(4);
            notifyListeners();
          }
        }
      } else {
        isSelectedButton[index] = false;
      }
    }
  }

}