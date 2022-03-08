import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';


import 'package:achieve_student_flutter/model/student_profile.dart';
import 'package:achieve_student_flutter/network_handler.dart';
import 'package:achieve_student_flutter/screens/login/login_screen.dart';
import 'package:base_x/base_x.dart';

import 'package:achieve_student_flutter/screens/report/report_screen.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart';

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(BuildContext context);

  int currentBottomNavBarIndex = 0;
  NetworkHandler networkHandler = NetworkHandler();
  StudentProfileModel studentProfileModel = StudentProfileModel();
  int? studentPercent;
  bool circular = true;
  bool imageCircular = true;
  FlutterSecureStorage storage = FlutterSecureStorage();
  double? studentPercentProgressBar;

  Future onReady() async {
    fetchData();
    fetchStudentPercent();
    circular = false;
    notifyListeners();
  }

  void fetchData() async {
    var response = await networkHandler.get("/student/getStudent");
    studentProfileModel = StudentProfileModel.fromJson(response);
    notifyListeners();
  }

  void fetchStudentPercent() async {
    var response = await networkHandler.get("/student/achievementsPercent");
    studentPercent = response;
    studentPercentProgressBar = studentPercent! / 100;
    notifyListeners();
  }

  exitButtonAction(context) {
    storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
  }

  MemoryImage getImageFromBase64(String base64String) {
    var firstDecode = base64Decode(base64String);
    var tempString = latin1.decode(firstDecode).replaceAll(RegExp("[^A-Za-z0-9+/=]+"), "");
    var secondDecode = base64Decode(tempString);
    return MemoryImage(secondDecode);
  }

  getImageFromGallery() async {
    String? accessToken = await storage.read(key: "token");
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 462, maxHeight: 462);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      var firstEncode = base64Encode(imageFile.readAsBytesSync());
      Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
      var secondEncode = stringToBase64Url.encode(firstEncode);
      Map<String, dynamic> bodyData = {
        "data": firstEncode,
        "format": "png",
        "listFileId": null
      };
      var response = await networkHandler.put("/student/changePhoto",
          {"Authorization": "Bearer $accessToken"}, bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        print(secondEncode);
        SnackBar(content: Text("Изображение профиля изменено."));
      } else {
        print(response.body);
        print(secondEncode);
        SnackBar(content: Text("Не удалось загрузить изображение профиля!"));
      }
    }
  }

  goToReportsScreen(context) {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => ReportScreen()));
  }

  Future<void> refresh() async {
    fetchData();
    fetchStudentPercent();
  }
}
