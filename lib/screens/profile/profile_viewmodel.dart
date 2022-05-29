import 'dart:convert';
import 'dart:io';

import 'package:achieve_student_flutter/model/student/student_profile.dart';
import 'package:achieve_student_flutter/screens/pgas/pgas_screen.dart';
import 'package:achieve_student_flutter/utils/network_handler.dart';
import 'package:achieve_student_flutter/screens/login/login_screen.dart';

import 'package:achieve_student_flutter/screens/report/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(BuildContext context);

  int currentBottomNavBarIndex = 0;
  NetworkHandler networkHandler = NetworkHandler();
  StudentProfileModel? studentProfileModel;
  int? studentPercent;
  int? course;
  bool isStudentDataInit = false;
  bool isStudyInit = false;
  bool isPercentInit = false;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  double? studentPercentProgressBar;
  bool isCreated = false;
  List<bool> isSelectedButton = [true, false];
  Box? profileBox;

  Future onReady() async {
    await fetchStudentDataFromApi();
    await fetchStudentPercent();
    await fetchStudy();
    notifyListeners();
  }

  fetchStudentDataFromApi() async {
    var response = await networkHandler.get("/student/getStudent", null);
    if (response.statusCode == 200 || response.statusCode == 200) {
      studentProfileModel = StudentProfileModel.fromJson(json.decode(response.body));
      isStudentDataInit = true;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchStudentDataFromApi();
    }
  }

  fetchStudy() async {
    var response = await networkHandler.get("/student/getStudy", null);
    if (response.statusCode == 200 || response.statusCode == 201) {
      course = json.decode(response.body)["course"];
      isStudyInit = true;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchStudy();
    }
  }

  fetchStudentPercent() async {
    var response = await networkHandler.get("/student/achievementsPercent", null);
    if (response.statusCode == 200 || response.statusCode == 201) {
      studentPercent = json.decode(response.body);
      studentPercentProgressBar = studentPercent! / 100;
      isPercentInit = true;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchStudentPercent();
    }
  }

  exitButtonAction(context) {
    storage.delete(key: "token");
    storage.delete(key: "refresh_token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
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

  pickImage(ImageSource source, context) async {
    var accessToken = await storage.read(key: "token");
    try {
      final image = await ImagePicker().pickImage(source: source);
      File imageFile = File(image!.path);
      var decodedImage = decodeImage(File(imageFile.path).readAsBytesSync());
      var thumbnail = copyResize(decodedImage!, width: 120, height: 120);
      File newFile = File(image.path)..writeAsBytesSync(encodePng(thumbnail));
      var firstEncode = base64Encode(newFile.readAsBytesSync());
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      var secondEncode = stringToBase64.encode(firstEncode);
      Map<String, dynamic> bodyData = {
        "data": secondEncode.toString(),
        "format": "png",
        "listFileId": null
      };

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      var response =
          await networkHandler.put("/student/changePhoto", headers, bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        refresh();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Фото профиля успешно изменено.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ошибка при изменении изображения профиля!")));
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Не удалось загрузить изображение: $e")));
    }
  }

  goToReportsScreen(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ReportScreen()));
  }

  goToPgasScreen(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const PgasScreen()));
  }

  Future<void> refresh() async {
    fetchStudentDataFromApi();
    fetchStudentPercent();
    notifyListeners();
  }

  onChangeToggle(int newIndex) {
    for (int index = 0; index < isSelectedButton.length; index++) {
      if (index == newIndex) {
        if (isSelectedButton[index] != true) {
          isSelectedButton[index] = true;
          if (newIndex == 0) {
            isCreated = false;
            notifyListeners();
          } else {
            isCreated = true;
            notifyListeners();
          }
        }
      } else {
        isSelectedButton[index] = false;
      }
    }
  }

  openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    profileBox = await Hive.openBox("profileData");
    notifyListeners();
  }
}
