import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/achievement/created_achievement/created_achievement.dart';
import 'package:achieve_student_flutter/screens/achievements/created_achievements/created_detail_achieve_screen.dart';
import 'package:achieve_student_flutter/screens/achievements/proof_achievements/proof_detail_achieve_screen.dart';
import 'package:achieve_student_flutter/utils/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../../model/proof_achievement/proof_achieve.dart';
import '../../../utils/network_handler.dart';

class RequestsViewModel extends BaseViewModel {
  RequestsViewModel(BuildContext context);

  List<CreatedAchievementModel> createdAchievements = [];
  List<ProofAchieveModel> proofAchievements = [];
  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool circle = true;
  bool isProof = true;
  Parser parser = Parser();
  List<bool> isSelectedButton = [true, false];

  Future onReady() async {
    fetchRequestAchievements("proof");
    fetchRequestAchievements("create");
    notifyListeners();
  }

  fetchRequestAchievements(String? type) async {
    var response;
    if (type == "create") {
      response = await networkHandler.get("/student/achievementsCreated");
      if (response.statusCode == 200 || response.statusCode == 200) {
        createdAchievements = parser.parseCreatedAchievements(json.decode(response.body));
        notifyListeners();
      } else if (response.statusCode == 403) {
        var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
        await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
        return fetchRequestAchievements("create");
      }
    } else {
      response = await networkHandler.get("/student/proof");
      if (response.statusCode == 200 || response.statusCode == 200) {
        proofAchievements = parser.parseProofAchievements(json.decode(response.body));
        circle = false;
        notifyListeners();
      } else if (response.statusCode == 403) {
        var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
        await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
        return fetchRequestAchievements("proof");
      }
    }
  }

  changeRequestsCreatedAchievements(context) {
    isProof = false;
    notifyListeners();
  }

  changeRequestsProofAchievements(context) {
    isProof = true;
    notifyListeners();
  }

  Uint8List getImage(String base64String) {
    var firstDecode = base64Decode(base64String);
    String tempString = String.fromCharCodes(firstDecode).replaceAll("\n", "");
    var secondDecode = base64Decode(tempString);
    return secondDecode;
  }

  goToDetailCreatedAchievement(context) {
    Navigator.push(context, new MaterialPageRoute(
        builder: (context) => CreatedDetailAchieveScreen()));
  }

  goToDetailProofAchievement(context) {
    Navigator.push(context, new MaterialPageRoute(
        builder: (context) => ProofDetailAchieveScreen()));
  }

  onChangeToggle(int newIndex, BuildContext context) {
    for (int index = 0; index < isSelectedButton.length; index++) {
      if (index == newIndex) {
        if (isSelectedButton[index] != true) {
          isSelectedButton[index] = true;
          if (newIndex == 0) {
            changeRequestsProofAchievements(context);
            notifyListeners();
          } else if (newIndex == 1) {
            changeRequestsCreatedAchievements(context);
            notifyListeners();
          }
        }
      } else {
        isSelectedButton[index] = false;
      }
    }
  }
}