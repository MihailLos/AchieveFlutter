import 'dart:convert';

import 'package:achieve_student_flutter/model/achievement/created_achievement/created_achievement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/network_handler.dart';
import '../created_achievements/created_detail_achieve_screen.dart';

class CreatedAchieveProfileViewModel extends BaseViewModel {
  CreatedAchieveProfileViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  List<CreatedAchievementModel> createdProfileAchievements = [];
  bool circle = true;


  Future onReady() async {
    fetchCreatedProfileAchievements();
    notifyListeners();
  }

  void fetchCreatedProfileAchievements() async {
    var response = await networkHandler.get("/student/achievementsCreated");
    createdProfileAchievements = parseCreatedProfileAchievements(response);
    circle = false;
    notifyListeners();
  }

  List<CreatedAchievementModel> parseCreatedProfileAchievements(List response) {
    return response
        .map<CreatedAchievementModel>(
            (json) => CreatedAchievementModel.fromJson(json))
        .toList();
  }

  Future<MemoryImage?> getImageForCreated(int index) async {
    if (createdProfileAchievements[index].data!.isEmpty) {
      return null;
    } else {
      var firstDecode =
      base64Decode(createdProfileAchievements[index].data.toString());
      String tempString =
      String.fromCharCodes(firstDecode).replaceAll("\n", "");
      var secondDecode = base64Decode(tempString);
      return MemoryImage(secondDecode);
    }
  }

  goToDetailCreatedAchievement(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => CreatedDetailAchieveScreen()));
  }
}