import 'dart:convert';

import 'package:achieve_student_flutter/model/achievement/created_achievement/created_achievement.dart';
import 'package:achieve_student_flutter/utils/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/network_handler.dart';
import '../created_achievements/created_detail_achieve_screen.dart';

class CreatedAchieveProfileViewModel extends BaseViewModel {
  CreatedAchieveProfileViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<CreatedAchievementModel> createdProfileAchievements = [];
  Parser parser = Parser();
  bool circle = true;

  Future onReady() async {
    await fetchCreatedProfileAchievements();
    notifyListeners();
  }

  Future onReadyAnotherStudent() async {
    String? studentId = await storage.read(key: "student_id");
    notifyListeners();
    await fetchCreatedProfileAchievements(int.parse(studentId!));
    notifyListeners();
  }

  fetchCreatedProfileAchievements([int? studentId]) async {
    circle = true;
    Response response;
    studentId == null ? response = await networkHandler.get("/student/achievementsCreated") :
    response = await networkHandler.get("/student/achievementsCreated?studentId=$studentId");

    if (response.statusCode == 200 || response.statusCode == 200) {
      createdProfileAchievements = parser.parseCreatedProfileAchievements(json.decode(response.body));
      circle = false;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchCreatedProfileAchievements();
    }
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatedDetailAchieveScreen()));
  }
}