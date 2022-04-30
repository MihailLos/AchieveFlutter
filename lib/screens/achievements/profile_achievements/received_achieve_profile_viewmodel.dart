import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/screens/achievements/received_achievements/received_detail_achieve_screen.dart';
import 'package:achieve_student_flutter/utils/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../../../model/achievement/achieve_category.dart';
import '../../../model/achievement/received_achievement/received_achievement.dart';
import '../../../utils/network_handler.dart';

class ReceivedAchieveProfileViewModel extends BaseViewModel {
  ReceivedAchieveProfileViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<ReceivedAchievementModel> receivedProfileAchievements = [];
  List<ReceivedAchievementModel> filteredReceivedProfileAchievements = [];
  List<AchieveCategoryModel> achieveCategoryList = [];
  AchieveCategoryModel? achieveCategoryModel;
  Parser parser = Parser();
  bool circle = true;
  bool isVisibleFilters = false;

  Future onReady() async {
    await fetchAchieveCategory();
    await fetchReceivedProfileAchievements();
    notifyListeners();
  }

  Future onReadyAnotherStudent() async {
    String? studentId = await storage.read(key: "student_id");
    notifyListeners();
    await fetchAchieveCategory();
    await fetchReceivedProfileAchievements(null, int.parse(studentId!));
    notifyListeners();
  }

  fetchReceivedProfileAchievements([int? categoryId, int? studentId]) async {
    Response response;
    circle = true;
    if (categoryId != null) {
      if (studentId == null) {
        response = await networkHandler
            .get("/student/achievementsReceived/3?categoryId=$categoryId");
      } else {
        response = await networkHandler
            .get("/student/achievementsReceived/3?categoryId=$categoryId&studentId=$studentId");
      }
    } else {
      if (studentId == null) {
        response = await networkHandler.get("/student/achievementsReceived/3");
      } else {
        response = await networkHandler.get("/student/achievementsReceived/3?studentId=$studentId");
      }
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

  fetchAchieveCategory() async {
    var response = await networkHandler.get("/categories");
    if (response.statusCode == 200 || response.statusCode == 200) {
      achieveCategoryList = parser.parseAchieveCategory(json.decode(response.body));
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchAchieveCategory();
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
              value: achieveCategoryModel,
              items: achieveCategoryList.map((e) {
                return DropdownMenuItem(
                  child: Text(e.categoryName.toString()),
                  value: e,
                );
              }).toList(),
              hint: const Text("Категория достижения"),
              onChanged: (value) async {
                String? studentId = await storage.read(key: "student_id");
                achieveCategoryModel = value!;
                studentId == null ? fetchReceivedProfileAchievements(
                    achieveCategoryModel!.categoryId) :
                fetchReceivedProfileAchievements(
                    achieveCategoryModel!.categoryId, int.parse(studentId));
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceivedDetailAchieveScreen()));
  }
}