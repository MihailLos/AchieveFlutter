import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/screens/achievements/received_achievements/received_detail_achieve_screen.dart';
import 'package:achieve_student_flutter/utils/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../../model/achievement/achieve_category.dart';
import '../../../model/achievement/received_achievement/received_achievement.dart';
import '../../../utils/network_handler.dart';

class ReceivedAchieveProfileViewModel extends BaseViewModel {
  ReceivedAchieveProfileViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  List<ReceivedAchievementModel> receivedProfileAchievements = [];
  List<ReceivedAchievementModel> filteredReceivedProfileAchievements = [];
  List<AchieveCategoryModel> achieveCategoryList = [];
  AchieveCategoryModel? achieveCategoryModel;
  Parser parser = Parser();
  bool circle = true;
  bool isVisibleFilters = false;

  Future onReady() async {
    fetchReceivedProfileAchievements();
    notifyListeners();
  }

  fetchReceivedProfileAchievements([int? categoryId]) async {
    var response;
    circle = true;
    if (categoryId != null) {
      response = await networkHandler
          .get("/student/achievementsReceived/3?categoryId=$categoryId");
    } else {
      response = await networkHandler.get("/student/achievementsReceived/3");
    }
    if (response.statusCode == 200 || response.statusCode == 200) {
      receivedProfileAchievements = parser.parseReceivedProfileAchievements(json.decode(response.body));
      filteredReceivedProfileAchievements = receivedProfileAchievements;
      notifyListeners();
      circle = false;
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchReceivedProfileAchievements();
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

  goToDetailReceivedAchievement(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => ReceivedDetailAchieveScreen()));
  }
}