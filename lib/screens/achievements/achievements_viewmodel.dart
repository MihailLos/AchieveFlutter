import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/achieve_category.dart';
import 'package:achieve_student_flutter/model/created_achievement.dart';
import 'package:achieve_student_flutter/model/proof_achieve.dart';
import 'package:achieve_student_flutter/network_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:stacked/stacked.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/received_achievement.dart';
import '../../model/unreceived_achievement.dart';

class AchievementsViewModel extends BaseViewModel {
  AchievementsViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  CreatedAchievementModel createdAchievementModel = CreatedAchievementModel();
  List<CreatedAchievementModel> createdProfileAchievements = [];
  List<CreatedAchievementModel> createdAchievements = [];
  List<ProofAchieveModel> proofAchievements = [];
  List<ReceivedAchievementModel> receivedProfileAchievements = [];
  List<ReceivedAchievementModel> filteredReceivedProfileAchievements = [];
  List<UnreceivedAchievementModel> unreceivedProfileAchievements = [];
  List<UnreceivedAchievementModel> filteredUnreceivedProfileAchievements = [];
  List<AchieveCategoryModel> achieveCategoryList = [];
  AchieveCategoryModel achieveCategoryModel = AchieveCategoryModel();
  bool circle = true;
  bool isVisibleFilters = false;
  bool isProof = true;
  bool isProofAchieveButtonTapped = true;
  bool isCreatedAchieveButtonTapped = false;

  Future onReadyCreatedAchieveGrid() async {
    fetchCreatedProfileAchievements();
    notifyListeners();
  }

  Future onReadyReceivedAchieveGrid() async {
    fetchReceivedProfileAchievements();
    fetchAchieveCategory();
    circle = false;
    notifyListeners();
  }

  Future onReadyUnreceived() async {
    fetchUnreceivedAchievements();
    circle = false;
    notifyListeners();
  }

  Future onReadyRequests() async {
    fetchRequestAchievements("create");
    fetchRequestAchievements("proof");
    circle = false;
    notifyListeners();
  }

  void fetchCreatedProfileAchievements() async {
    var response = await networkHandler.get("/student/achievementsCreated");
    createdProfileAchievements = parseCreatedProfileAchievements(response);
    circle = false;
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

  void fetchReceivedProfileAchievements([int? categoryId]) async {
    List response;
    if (categoryId != null) {
      response = await networkHandler
          .get("/student/achievementsReceived/3?categoryId=$categoryId");
    } else {
      response = await networkHandler.get("/student/achievementsReceived/3");
    }
    receivedProfileAchievements = parseReceivedProfileAchievements(response);
    filteredReceivedProfileAchievements = receivedProfileAchievements;
    circle = false;
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
        parseUnreceivedProfileAchievements(response);
    filteredUnreceivedProfileAchievements = unreceivedProfileAchievements;
    circle = false;
    notifyListeners();
  }

  void fetchAchieveCategory() async {
    var response = await networkHandler.get("/categories");
    achieveCategoryList = parseAchieveCategory(response);
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

  List<ReceivedAchievementModel> parseReceivedProfileAchievements(
      List response) {
    return response
        .map<ReceivedAchievementModel>(
            (json) => ReceivedAchievementModel.fromJson(json))
        .toList();
  }

  List<UnreceivedAchievementModel> parseUnreceivedProfileAchievements(
      List response) {
    return response
        .map<UnreceivedAchievementModel>(
            (json) => UnreceivedAchievementModel.fromJson(json))
        .toList();
  }

  List<AchieveCategoryModel> parseAchieveCategory(List response) {
    return response
        .map<AchieveCategoryModel>(
            (json) => AchieveCategoryModel.fromJson(json))
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

  Future<MemoryImage?> getImageForReceived(int index) async {
    if (receivedProfileAchievements[index].achieveData == null) {
      return null;
    } else {
      var firstDecode = base64Decode(
          receivedProfileAchievements[index].achieveData.toString());
      String tempString =
          String.fromCharCodes(firstDecode).replaceAll("\n", "");
      var secondDecode = base64Decode(tempString);
      return MemoryImage(secondDecode);
    }
  }

  Uint8List getImage(String base64String) {
    var firstDecode = base64Decode(base64String);
    String tempString = String.fromCharCodes(firstDecode).replaceAll("\n", "");
    var secondDecode = base64Decode(tempString);
    return secondDecode;
  }

  showFilters(context) {
    return Visibility(
      visible: isVisibleFilters,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: DropdownButton<AchieveCategoryModel>(
              isExpanded: true,
              value: null,
              items: achieveCategoryList.map((e) {
                return DropdownMenuItem(
                  child: Text(e.categoryName.toString()),
                  value: e,
                );
              }).toList(),
              hint: Text("Категория достижения"),
              onChanged: (value) {
                achieveCategoryModel = value!;
                fetchReceivedProfileAchievements(
                    achieveCategoryModel.categoryId);
                notifyListeners();
              }),
        ),
      ),
    );
  }

  changeVisibility(context) {
    isVisibleFilters = !isVisibleFilters;
    notifyListeners();
  }

  changeRequestsCreatedAchievements(context) {
    isProof = false;
    notifyListeners();
  }

  changeRequestsProofAchievements(context) {
    isProof = true;
    notifyListeners();
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
}
