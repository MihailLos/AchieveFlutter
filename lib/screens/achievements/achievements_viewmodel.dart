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
              IconButton(
                onPressed: () {
                  changeVisibility(context);
                },
                icon: Icon(Icons.filter_alt),
                color: Colors.blueAccent,
              ),
              showFilters(context),
              GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
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
                                      filteredReceivedProfileAchievements[index]
                                              .statusReward!
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

  unreceivedAchievementsList(context) {
    return filteredUnreceivedProfileAchievements.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: ListView.builder(
                itemCount: filteredUnreceivedProfileAchievements.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    getImage(filteredUnreceivedProfileAchievements[index].achieveData.toString()),
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.fill,),
                                ),
                                Positioned(
                                    child: ClipOval(
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        color: Colors.white,
                                        child: Image.memory(getImage(
                                            filteredUnreceivedProfileAchievements[index]
                                                .categoryData.toString()), width: 15, height: 15, color: Colors.black,),
                                      ),
                                    ),
                                bottom: 0,
                                right: 1,)
                              ],
                            ),
                            SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(filteredUnreceivedProfileAchievements[index].achieveName.toString(),
                                  style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),),
                                  SizedBox(height: 12,),
                                  Text(filteredUnreceivedProfileAchievements[index].achieveDescription.toString(),
                                  style: GoogleFonts.openSans(
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                  ),)
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("+${filteredUnreceivedProfileAchievements[index].score.toString()}",
                                style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF4065D8)),),
                                Image.asset("assets/images/prize_icon.png", width: 30, height: 30,),
                                Image.memory(getImage(filteredUnreceivedProfileAchievements[index].rewardData.toString()), width: 30, height: 30,)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }));
  }

  createdAchievementsList(context) {
    return createdAchievements.isEmpty
        ? Center(
      child: CircularProgressIndicator(),
    ) : Expanded(
        child: ListView.builder(
          itemCount: createdAchievements.length,
            itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          getImage(createdAchievements[index].data.toString()),
                          width: 65,
                          height: 65,
                          fit: BoxFit.fill,),
                      ),
                      SizedBox(width: 16,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Создание достижения",
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),),
                            SizedBox(height: 12,),
                            Text(createdAchievements[index].achieveName.toString(),
                              style: GoogleFonts.openSans(
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey
                              ),),
                            Text(createdAchievements[index].statusActive.toString(),
                              style: GoogleFonts.openSans(
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey
                              ),)
                          ],
                        ),
                      ),
                      createdAchievements[index].statusActive.toString() == "Одобрено" || createdAchievements[index].statusActive.toString() == "Активно" ?
                          Icon(Icons.check, color: Colors.green, size: 32,) :
                      createdAchievements[index].statusActive.toString() == "Отклонено" || createdAchievements[index].statusActive.toString() == "Устарело" ?
                      Icon(Icons.clear, color: Colors.red, size: 32,) :
                      Icon(Icons.access_time_outlined, color: Colors.black, size: 32,)
                    ],
                  ),
                ),
              ),
            );
            }
        )
    );
  }

  proofAchievementsList(context) {
    return proofAchievements.isEmpty
        ? Center(
      child: CircularProgressIndicator(),
    ) : Expanded(
        child: ListView.builder(
            itemCount: proofAchievements.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            getImage(proofAchievements[index].achieveData.toString()),
                            width: 65,
                            height: 65,
                            fit: BoxFit.fill,),
                        ),
                        SizedBox(width: 16,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Получение достижения",
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),),
                              SizedBox(height: 12,),
                              Text(proofAchievements[index].achieveName.toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                ),),
                              Text(proofAchievements[index].statusRequestName.toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                ),),
                              Text(proofAchievements[index].dateProof.toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                ),)
                            ],
                          ),
                        ),
                        proofAchievements[index].statusRequestName.toString() == "Подтверждено" ?
                        Icon(Icons.check, color: Colors.green, size: 32,) :
                        proofAchievements[index].statusRequestName.toString() == "Отклонено" ?
                        Icon(Icons.clear, color: Colors.red, size: 32,) :
                        proofAchievements[index].statusRequestName.toString() == "Просмотрено" ?
                        Icon(Icons.remove_red_eye_outlined, color: Colors.blue, size: 32,) :
                        Icon(Icons.access_time_outlined, color: Colors.black, size: 32,)
                      ],
                    ),
                  ),
                ),
              );
            }
        )
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
