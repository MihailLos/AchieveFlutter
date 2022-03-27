import 'dart:convert';

import 'package:achieve_student_flutter/model/student/student_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:achieve_student_flutter/utils/network_handler.dart';

class DetailStudentViewModel extends BaseViewModel {
  DetailStudentViewModel(BuildContext context);

  FlutterSecureStorage storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  StudentProfileModel? studentProfileModel;
  bool circular = true;
  int? studentPercent;
  int? course;
  double? studentPercentProgressBar;

  Future onReady() async {
    fetchAnotherStudy();
    fetchAnotherStudent();
    fetchAnotherStudentPercent();
    notifyListeners();
  }

  fetchAnotherStudent() async {
    circular = true;
    notifyListeners();
    String? studentId = await storage.read(key: "student_id");
    var response = await networkHandler.get("/student/getStudent?studentId=${int.parse(studentId.toString())}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      studentProfileModel = StudentProfileModel.fromJson(json.decode(response.body));
      circular = false;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchAnotherStudent();
    }
  }

  fetchAnotherStudy() async {
    String? studentId = await storage.read(key: "student_id");
    var response = await networkHandler.get("/student/getStudy?studentId=${int.parse(studentId.toString())}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      course = json.decode(response.body)["course"];
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchAnotherStudy();
    }
  }

  fetchAnotherStudentPercent() async {
    notifyListeners();
    String? studentId = await storage.read(key: "student_id");
    var response = await networkHandler.get("/student/achievementsPercent?studentId=${int.parse(studentId.toString())}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      studentPercent = json.decode(response.body);
      studentPercentProgressBar = studentPercent! / 100;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchAnotherStudentPercent();
    }
  }

  Future<MemoryImage?> getImageFromBase64() async {
    if (studentProfileModel!.data == null) {
      return null;
    } else {
      var firstDecode = base64Decode(studentProfileModel!.data.toString());
      var tempString = latin1.decode(firstDecode).replaceAll("\n", "");
      var secondDecode = base64Decode(tempString);
      return MemoryImage(secondDecode);
    }
  }

  Future<String?> getName() async {
    if (studentProfileModel!.firstName == null && studentProfileModel!.lastName == null) {
      return null;
    } else {
      return "${studentProfileModel!.firstName.toString()} ${studentProfileModel!.lastName.toString()}";
    }
  }

  Future<String?> getInstitute() async {
    if (studentProfileModel!.instituteFullName == null) {
      return null;
    } else {
      return studentProfileModel!.instituteFullName.toString();
    }
  }

  Future<String?> getStream() async {
    if (studentProfileModel!.streamFullName == null) {
      return null;
    } else {
      return studentProfileModel!.streamFullName.toString();
    }
  }

  Future<String?> getGroup() async {
    if (studentProfileModel!.groupName == null) {
      return null;
    } else {
      return studentProfileModel!.groupName.toString();
    }
  }

  goToRatingScreen(context) async {
    Navigator.pop(context);
    await storage.delete(key: "student_id");
  }
}