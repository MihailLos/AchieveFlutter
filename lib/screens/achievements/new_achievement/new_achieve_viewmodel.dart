import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/achievement/achieve_category.dart';
import 'package:achieve_student_flutter/model/achievement/created_achievement/created_achievement.dart';
import 'package:achieve_student_flutter/model/reward/reward.dart';
import 'package:achieve_student_flutter/utils/network_handler.dart';
import 'package:achieve_student_flutter/utils/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';


class NewAchievementViewModel extends BaseViewModel {
  NewAchievementViewModel(BuildContext context);

  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = FlutterSecureStorage();
  CreatedAchievementModel createdAchievementModel = CreatedAchievementModel();
  List<AchieveCategoryModel> achieveCategoryList = [];
  List<RewardModel> rewardList = [];
  RewardModel? chosenReward;
  AchieveCategoryModel? achieveCategoryModel;
  bool circle = true;
  Parser parser = Parser();

  File? newAchieveImage;
  String? decodedNewAchieveImage;
  var newAchievementTitle = TextEditingController();
  var newAchievementDescription = TextEditingController();
  var newAchievementScore = TextEditingController();
  DateTime? startNewAchieveDate;
  DateTime? endNewAchieveDate;
  String? startNewAchieveDateString;
  String? endNewAchieveDateString;

  Future onReady() async {
    fetchAchieveCategory();
    fetchRewards();
    notifyListeners();
  }

  fetchAchieveCategory() async {
    var response = await networkHandler.get("/categories");
    if (response.statusCode == 200 || response.statusCode == 200) {
      achieveCategoryList = parser.parseAchieveCategory(json.decode(response.body));
      circle = false;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchAchieveCategory();
    }
  }

  fetchRewards() async {
    var response = await networkHandler.get("/rewards");
    if (response.statusCode == 200 || response.statusCode == 200) {
      rewardList = parser.parseRewards(json.decode(response.body));
      circle = false;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchRewards();
    }
  }

  Uint8List getImage(String base64String) {
    var firstDecode = base64Decode(base64String);
    String tempString = String.fromCharCodes(firstDecode).replaceAll("\n", "");
    var secondDecode = base64Decode(tempString);
    return secondDecode;
  }

  pickNewAchievementImage(context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      newAchieveImage = File(image!.path);
      var decodedImage = decodeImage(File(newAchieveImage!.path).readAsBytesSync());
      File newFile = File(image.path)..writeAsBytesSync(encodePng(decodedImage!));
      var firstEncode = base64Encode(newFile.readAsBytesSync());
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      decodedNewAchieveImage = stringToBase64.encode(firstEncode);
    } on PlatformException catch (e) {
      print("Не удалось загрузить изображение: $e");
    }
    notifyListeners();
  }

  sendNewAchievementRequest(context) async {
    var accessToken = await storage.read(key: "token");
    if (newAchievementTitle.text.isNotEmpty &&
        newAchievementDescription.text.isNotEmpty &&
        decodedNewAchieveImage!.isNotEmpty && newAchievementScore.text.isNotEmpty && startNewAchieveDateString!.isNotEmpty) {
      Map<String, dynamic> bodyData = {
        "achieveDescription": newAchievementDescription.text,
        "achieveEndDate": endNewAchieveDateString == null ? null : endNewAchieveDateString!,
        "achieveName": newAchievementTitle.text,
        "achieveStartDate": startNewAchieveDateString!,
        "categoryId": achieveCategoryModel!.categoryId,
        "format": "png",
        "rewardId": chosenReward!.rewardId,
        "achieveScore": int.parse(newAchievementScore.text),
        "photo": decodedNewAchieveImage.toString(),
      };
      print(bodyData);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      print(headers);

      var response = await networkHandler.post(
          "/student/newAchieve", headers, bodyData);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ваша заявка успешно отправлена.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка при отправке заявки!")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Заполните все поля заявки!")));
    }
  }

  goToUnreceivedFromNewAchievement(context) {
    Navigator.pop(context);
  }

  getTextFromStartDateNewAchieve() {
    if (startNewAchieveDate == null) {
      return Text("Дата начала", style: TextStyle(color: Colors.black),);
    } else {
      if (startNewAchieveDate!.month < 10) {
        if (startNewAchieveDate!.day < 10) {
          startNewAchieveDateString = "${startNewAchieveDate!.year}-0${startNewAchieveDate!.month}-0${startNewAchieveDate!.day}";
          return Text(startNewAchieveDateString.toString(), style: TextStyle(color: Colors.black));
        } else {
          startNewAchieveDateString = "${startNewAchieveDate!.year}-0${startNewAchieveDate!.month}-${startNewAchieveDate!.day}";
          return Text(startNewAchieveDateString.toString(), style: TextStyle(color: Colors.black));
        }
      } else {
        startNewAchieveDateString = "${startNewAchieveDate!.year}-${startNewAchieveDate!.month}-${startNewAchieveDate!.day}";
        return Text(startNewAchieveDateString.toString(), style: TextStyle(color: Colors.black));
      }
    }
  }

  getTextFromEndDateNewAchieve() {
    if (endNewAchieveDate == null) {
      return Text("Дата окончания", style: TextStyle(color: Colors.black));
    } else {
      if (endNewAchieveDate!.month < 10) {
        if (endNewAchieveDate!.day < 10) {
          endNewAchieveDateString = "${endNewAchieveDate!.year}-0${endNewAchieveDate!.month}-0${endNewAchieveDate!.day}";
          return Text(endNewAchieveDateString.toString(), style: TextStyle(color: Colors.black));
        } else {
          endNewAchieveDateString = "${endNewAchieveDate!.year}-0${endNewAchieveDate!.month}-${endNewAchieveDate!.day}";
          return Text(endNewAchieveDateString.toString(), style: TextStyle(color: Colors.black));
        }
      } else {
        endNewAchieveDateString = "${endNewAchieveDate!.year}-${endNewAchieveDate!.month}-${endNewAchieveDate!.day}";
        return Text(endNewAchieveDateString.toString(), style: TextStyle(color: Colors.black));
      }
    }
  }

  void pickStartNewAchieveDate(context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5)
    );
    if (newDate == null) return;

    startNewAchieveDate = newDate;
    notifyListeners();
  }

  void pickEndNewAchieveDate(context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5)
    );
    if (newDate == null) return;

    endNewAchieveDate = newDate;
    notifyListeners();
  }
}
