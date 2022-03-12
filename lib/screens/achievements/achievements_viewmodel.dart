import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/achieve_category.dart';
import 'package:achieve_student_flutter/model/created_achievement.dart';
import 'package:achieve_student_flutter/network_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:stacked/stacked.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/received_achievement.dart';

class AchievementsViewModel extends BaseViewModel {
  AchievementsViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  CreatedAchievementModel createdAchievementModel = CreatedAchievementModel();
  List<CreatedAchievementModel> createdProfileAchievements = [];
  List<ReceivedAchievementModel> receivedProfileAchievements = [];
  List<ReceivedAchievementModel> filteredReceivedProfileAchievements = [];
  List<AchieveCategoryModel> achieveCategoryList = [];
  AchieveCategoryModel achieveCategoryModel = AchieveCategoryModel();
  bool circle = true;
  bool isVisibleFilters = false;

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

  void fetchCreatedProfileAchievements() async {
    var response = await networkHandler.get("/student/achievementsCreated");
    createdProfileAchievements = parseCreatedProfileAchievements(response);
    circle = false;
    notifyListeners();
  }

  void fetchReceivedProfileAchievements([int? categoryId]) async {
    List response;
    if (categoryId != null) {
      response = await networkHandler.get("/student/achievementsReceived/3?categoryId=$categoryId");
    } else {
      response = await networkHandler.get("/student/achievementsReceived/3");
    }
    receivedProfileAchievements = parseReceivedProfileAchievements(response);
    filteredReceivedProfileAchievements = receivedProfileAchievements;
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

  createdProfileAchievementsGrid(context) {
    return createdProfileAchievements.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: createdProfileAchievements.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(
                future: getImageForCreated(index),
                builder: (context, snapshot) {
                  if (snapshot.hasData || snapshot.data != null) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: snapshot.data as ImageProvider,
                              fit: BoxFit.fill),
                          border: Border.all(color: Colors.lightBlue, width: 4),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Color(0xffbfbfbf),
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  "${createdProfileAchievements[index].achieveName.toString()}",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Произошла ошибка"),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          );
  }

  receivedProfileAchievementsGrid(context) {
    return filteredReceivedProfileAchievements.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
      children: [
        IconButton(onPressed: () {changeVisibility(context);}, icon: Icon(Icons.filter_alt), color: Colors.blueAccent,),
        showFilters(context),
        GridView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: filteredReceivedProfileAchievements.length,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: getImageForReceived(index),
              builder: (context, snapshot) {
                if (snapshot.hasData || snapshot.data != null) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: snapshot.data as ImageProvider,
                            fit: BoxFit.fill),
                        border: Border.all(
                            color:
                            filteredReceivedProfileAchievements[index].statusReward!
                                ? Colors.green
                                : Colors.orange,
                            width: 4),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color(0xffbfbfbf),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                "${filteredReceivedProfileAchievements[index].achieveName.toString()}",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Произошла ошибка"),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
      ],
    );
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
                fetchReceivedProfileAchievements(achieveCategoryModel.categoryId);
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
