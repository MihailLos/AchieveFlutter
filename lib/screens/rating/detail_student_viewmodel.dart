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
    circular = false;
    notifyListeners();
  }

  void getStudent() async {
    String? studentId = await storage.read(key: "student_id");
    var response = await networkHandler.get("/student/getStudent?studentId=${int.parse(studentId.toString())}");
    studentProfileModel = StudentProfileModel.fromJson(response);
    notifyListeners();
  }

  void fetchStudentPercent() async {
    String? studentId = await storage.read(key: "student_id");
    var response = await networkHandler.get("/student/achievementsPercent?studentId=${int.parse(studentId.toString())}");
    studentPercent = response;
    studentPercentProgressBar = studentPercent! / 100;
    notifyListeners();
  }

  MemoryImage getImageFromBase64(String base64String) {
    var firstDecode = base64Decode(base64String);
    var tempString = latin1.decode(firstDecode).replaceAll(RegExp("[^A-Za-z0-9+/=]+"), "");
    var secondDecode = base64Decode(tempString);
    return MemoryImage(secondDecode);
  }

  goToRatingScreen(context) async {
    Navigator.pop(context);
    await storage.delete(key: "student_id");
  }
}