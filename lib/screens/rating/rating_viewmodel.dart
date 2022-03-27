import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/education/group.dart';
import 'package:achieve_student_flutter/model/education/institute.dart';
import 'package:achieve_student_flutter/model/education/stream.dart';
import 'package:achieve_student_flutter/model/student/rating_student.dart';
import 'package:achieve_student_flutter/utils/network_handler.dart';
import 'package:achieve_student_flutter/screens/rating/detail_student_screen.dart';
import 'package:achieve_student_flutter/utils/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

class RatingViewModel extends BaseViewModel {
  RatingViewModel(BuildContext context);

  List<StudentRatingModel> filteredStudents = [];
  List<StudentRatingModel> fetchedStudents = [];
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController searchController = TextEditingController();
  List<InstituteModel> institutesList = [];
  List<StreamModel> streamsList = [];
  List<GroupModel> groupsList = [];
  InstituteModel? filterInstitute;
  StreamModel? filterStream;
  GroupModel? filterGroup;
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool isVisibleFilters = false;
  Parser parser = Parser();
  bool circle = true;
  List<bool> isSelectedButton = [true, false, false];

  Future onReady() async {
    await fetchStudentsTop(10);
    await fetchInstitutes();
    filteredStudents.isNotEmpty && institutesList.isNotEmpty ? circle = false : circle = true;
    notifyListeners();
  }

  Future<void> searchAction() async {
    filteredStudents = fetchedStudents
        .where((element) {
      return element.lastName!
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    })
        .toList();
    notifyListeners();
  }

  Uint8List getStudentImage(String base64String) {
    var firstDecode = base64Decode(base64String);
    String secondDecode = latin1.decode(firstDecode).replaceAll("\n", "");
    var decodedImage = base64Decode(secondDecode);
    return decodedImage;
  }

  fetchStudentsTop(int topCount) async {
    var response = await networkHandler.get("/student/students${topCount.toString()}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      fetchedStudents = parser.parseStudents(json.decode(response.body));
      filteredStudents = fetchedStudents;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchStudentsTop(topCount);
    }
  }

  fetchInstitutes() async {
    var response = await networkHandler.get("/education/institutions");
    if (response.statusCode == 200 || response.statusCode == 200) {
      institutesList = parseInstitutes(json.decode(response.body));
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchInstitutes();
    }
  }

  void fetchStreams() async {
    var response = await networkHandler
        .get("/education/stream/${filterInstitute!.instituteId}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      streamsList = parseStreams(json.decode(response.body));
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchStreams();
    }
  }

  void fetchGroups() async {
    var response =
        await networkHandler.get("/education/group/${filterStream!.streamId}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      groupsList = parseGroups(json.decode(response.body));
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchGroups();
    }
  }

  List<InstituteModel> parseInstitutes(List response) {
    return response
        .map<InstituteModel>((json) => InstituteModel.fromJson(json))
        .toList();
  }

  List<StreamModel> parseStreams(List response) {
    return response
        .map<StreamModel>((json) => StreamModel.fromJson(json))
        .toList();
  }

  List<GroupModel> parseGroups(List response) {
    return response
        .map<GroupModel>((json) => GroupModel.fromJson(json))
        .toList();
  }

  goToStudentDetail(context) {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => DetailStudentScreen()));
  }

  changeVisibility(context) {
    isVisibleFilters = !isVisibleFilters;
    notifyListeners();
  }

  onChangeInstituteFilter(InstituteModel? instituteModel) async {
    filterStream = null;
    filterGroup = null;
    filterInstitute = instituteModel;
    fetchStreams();
    var response = await networkHandler.get("/student/students100?filterName=Институт&filterId=${instituteModel!.instituteId}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      filteredStudents = parser.parseStudents(json.decode(response.body));
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return onChangeInstituteFilter(instituteModel);
    }
  }

  onChangeStreamFilter(StreamModel? streamModel) async {
    filterGroup = null;
    filterStream = streamModel;
    fetchGroups();
    notifyListeners();
    var response = await networkHandler.get("/student/students100?filterName=Направление&filterId=${streamModel!.streamId}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      filteredStudents = parser.parseStudents(json.decode(response.body));
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return onChangeStreamFilter(streamModel);
    }
  }

  onChangeGroupFilter(GroupModel? groupModel) async {
    filterGroup = groupModel;
    var response = await networkHandler.get("/student/students100?filterName=Группа&filterId=${groupModel!.groupId}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      filteredStudents = parser.parseStudents(json.decode(response.body));
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return onChangeGroupFilter(groupModel);
    }
  }

  onTapStudent(context, String studentId) async {
    await storage.write(key: "student_id", value: studentId);
    notifyListeners();
    goToStudentDetail(context);
  }

  onChangeToggle(int newIndex) async {
    for (int index = 0; index < isSelectedButton.length; index++) {
      if (index == newIndex) {
        if (isSelectedButton[index] != true) {
          isSelectedButton[index] = true;
          if (newIndex == 0) {
            circle = true;
            notifyListeners();
            fetchStudentsTop(10);
            circle = false;
            notifyListeners();
          } else if (newIndex == 1) {
            circle = true;
            notifyListeners();
            fetchStudentsTop(50);
            circle = false;
            notifyListeners();
          } else {
            circle = true;
            notifyListeners();
            fetchStudentsTop(100);
            circle = false;
            notifyListeners();
          }
        }
      } else {
        isSelectedButton[index] = false;
        notifyListeners();
      }
    }
  }
}
