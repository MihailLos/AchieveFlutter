import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/screens/achievements/created_detail_achieve_screen.dart';
import 'package:achieve_student_flutter/screens/achievements/proof_detail_achieve_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../model/created_achievement.dart';
import '../../model/proof_achieve.dart';
import '../../network_handler.dart';

class RequestsViewModel extends BaseViewModel {
  RequestsViewModel(BuildContext context);

  List<CreatedAchievementModel> createdAchievements = [];
  List<ProofAchieveModel> proofAchievements = [];
  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool circle = true;
  bool isProof = true;
  bool isProofAchieveButtonTapped = true;
  bool isCreatedAchieveButtonTapped = false;

  Future onReady() async {
    fetchRequestAchievements("create");
    fetchRequestAchievements("proof");
    notifyListeners();
  }

  void fetchRequestAchievements(String? type) async {
    List response;
    if (type == "create") {
      response = await networkHandler.get("/student/achievementsCreated");
      createdAchievements = parseCreatedAchievements(response);
    } else {
      response = await networkHandler.get("/student/proof");
      proofAchievements = parseProofAchievements(response);
    }
    circle = false;
    notifyListeners();
  }

  List<CreatedAchievementModel> parseCreatedAchievements(List response) {
    return response
        .map<CreatedAchievementModel>(
            (json) => CreatedAchievementModel.fromJson(json))
        .toList();
  }

  List<ProofAchieveModel> parseProofAchievements(List response) {
    return response
        .map<ProofAchieveModel>(
            (json) => ProofAchieveModel.fromJson(json))
        .toList();
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

  proofAchieveButtonActive(context) {
    isProofAchieveButtonTapped = true;
    isCreatedAchieveButtonTapped = false;
    notifyListeners();
  }

  createdAchieveButtonActive(context) {
    isProofAchieveButtonTapped = false;
    isCreatedAchieveButtonTapped = true;
    notifyListeners();
  }

  goToDetailCreatedAchievement(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => CreatedDetailAchieveScreen()));
  }

  goToDetailProofAchievement(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => ProofDetailAchieveScreen()));
  }
}