import 'dart:convert';

import 'package:achieve_student_flutter/model/student_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:achieve_student_flutter/network_handler.dart';

class DetailStudentViewModel extends BaseViewModel {
  DetailStudentViewModel(BuildContext context);

  FlutterSecureStorage storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  StudentProfileModel studentProfileModel = StudentProfileModel();
  bool circular = true;
  int? studentPercent;
  double? studentPercentProgressBar;

  Future onReady() async {
    getStudent();
    fetchStudentPercent();
  }

  void getStudent() async {
    String? studentId = await storage.read(key: "student_id");
    var response = await networkHandler.get("/student/getStudent?studentId=${int.parse(studentId.toString())}");
    studentProfileModel = StudentProfileModel.fromJson(response);
    circular = false;
    notifyListeners();
  }

  void fetchStudentPercent() async {
    String? studentId = await storage.read(key: "student_id");
    var response = await networkHandler.get("/student/achievementsPercent?studentId=${int.parse(studentId.toString())}");
    studentPercent = response;
    studentPercentProgressBar = studentPercent! / 100;
    notifyListeners();
  }

  Future<MemoryImage?> getImageFromBase64() async {
    if (studentProfileModel.data == null) {
      return null;
    } else {
      var firstDecode = base64Decode(studentProfileModel.data.toString());
      var tempString = latin1.decode(firstDecode).replaceAll("\n", "");
      var secondDecode = base64Decode(tempString);
      return MemoryImage(secondDecode);
    }
  }

  Future<String?> getName() async {
    if (studentProfileModel.firstName == null && studentProfileModel.lastName == null) {
      return null;
    } else {
      return "${studentProfileModel.firstName.toString()} ${studentProfileModel.lastName.toString()}";
    }
  }

  Future<String?> getInstitute() async {
    if (studentProfileModel.instituteFullName == null) {
      return null;
    } else {
      return studentProfileModel.instituteFullName.toString();
    }
  }

  Future<String?> getStream() async {
    if (studentProfileModel.streamFullName == null) {
      return null;
    } else {
      return studentProfileModel.streamFullName.toString();
    }
  }

  Future<String?> getGroup() async {
    if (studentProfileModel.groupName == null) {
      return null;
    } else {
      return studentProfileModel.groupName.toString();
    }
  }

  goToRatingScreen(context) async {
    Navigator.pop(context);
    await storage.delete(key: "student_id");
  }
}