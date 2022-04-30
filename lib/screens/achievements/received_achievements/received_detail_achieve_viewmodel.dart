import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/achievement/received_achievement/detail_received_achievement.dart';
import 'package:achieve_student_flutter/utils/network_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

class ReceivedDetailAchieveViewModel extends BaseViewModel {
  ReceivedDetailAchieveViewModel(BuildContext context);

  FlutterSecureStorage storage = const FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  DetailReceivedAchieveModel? receivedAchieve;
  bool circle = true;

  Future onReady() async {
    fetchDetailReceivedAchievement();
    notifyListeners();
  }

  fetchDetailReceivedAchievement() async {
    String? receivedAchieveId = await storage.read(key: "received_achieve_id");
    var response = await networkHandler.get("/student/achievementReceived/${int.parse(receivedAchieveId!)}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      receivedAchieve = DetailReceivedAchieveModel.fromJson(json.decode(response.body));
      circle = false;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchDetailReceivedAchievement();
    }
  }

  Uint8List getImage(String base64String) {
    var firstDecode = base64Decode(base64String);
    String tempString = String.fromCharCodes(firstDecode).replaceAll("\n", "");
    var secondDecode = base64Decode(tempString);
    return secondDecode;
  }

  getRewardAction(context) async {
    String? achieveId = await storage.read(key: "achieve_id");
    var accessToken = await storage.read(key: "token");

    Map<String, String> headersReward = {
      'Authorization': 'Bearer $accessToken',
    };

    var response = await networkHandler.put("/student/getReward/${int.parse(achieveId!)}", headersReward, null);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Награда получена. Поздравляем!")));
      Navigator.pop(context);
      fetchDetailReceivedAchievement();
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ошибка при получении награды.")));
    }
  }
}