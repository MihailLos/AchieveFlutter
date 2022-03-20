import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../model/achieve_category.dart';
import '../../model/received_achievement.dart';
import '../../network_handler.dart';

class ReceivedAchieveProfileViewModel extends BaseViewModel {
  ReceivedAchieveProfileViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  List<ReceivedAchievementModel> receivedProfileAchievements = [];
  List<ReceivedAchievementModel> filteredReceivedProfileAchievements = [];
  List<AchieveCategoryModel> achieveCategoryList = [];
  AchieveCategoryModel? achieveCategoryModel;
  bool circle = true;
  bool isVisibleFilters = false;


  Future onReady() async {
    fetchReceivedProfileAchievements();
    fetchAchieveCategory();
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
    notifyListeners();
  }

  void fetchAchieveCategory() async {
    var response = await networkHandler.get("/categories");
    achieveCategoryList = parseAchieveCategory(response);
    notifyListeners();
  }

  List<ReceivedAchievementModel> parseReceivedProfileAchievements(
      List response) {
    return response
        .map<ReceivedAchievementModel>(
            (json) => ReceivedAchievementModel.fromJson(json))
        .toList();
  }

  List<AchieveCategoryModel> parseAchieveCategory(List response) {
    return response
        .map<AchieveCategoryModel>(
            (json) => AchieveCategoryModel.fromJson(json))
        .toList();
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

  showFilters(context) {
    return Visibility(
      visible: isVisibleFilters,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: DropdownButton<AchieveCategoryModel>(
              isExpanded: true,
              value: achieveCategoryModel == null ? null : achieveCategoryModel,
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
                    achieveCategoryModel!.categoryId);
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
}