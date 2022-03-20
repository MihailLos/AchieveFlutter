import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../model/created_achievement.dart';
import '../../network_handler.dart';

class CreatedAchieveProfileViewModel extends BaseViewModel {
  CreatedAchieveProfileViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  List<CreatedAchievementModel> createdProfileAchievements = [];
  bool circle = true;


  Future onReady() async {
    fetchCreatedProfileAchievements();
    circle = false;
    notifyListeners();
  }

  void fetchCreatedProfileAchievements() async {
    var response = await networkHandler.get("/student/achievementsCreated");
    createdProfileAchievements = parseCreatedProfileAchievements(response);
    notifyListeners();
  }

  List<CreatedAchievementModel> parseCreatedProfileAchievements(List response) {
    return response
        .map<CreatedAchievementModel>(
            (json) => CreatedAchievementModel.fromJson(json))
        .toList()
        .where((element) =>
    element.statusActive.toString().contains("Активно") ||
        element.statusActive.toString().contains("Не активно"))
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
}