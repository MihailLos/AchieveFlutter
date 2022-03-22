import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/detail_received_achievement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../network_handler.dart';

class ReceivedDetailAchieveViewModel extends BaseViewModel {
  ReceivedDetailAchieveViewModel(BuildContext context);

  FlutterSecureStorage storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  DetailReceivedAchieveModel? receivedAchieve;
  bool circle = true;

  Future onReady() async {
    fetchDetailReceivedAchievement();
    notifyListeners();
  }

  void fetchDetailReceivedAchievement() async {
    String? receivedAchieveId = await storage.read(key: "received_achieve_id");
    var response = await networkHandler.get("/student/achievementReceived/${int.parse(receivedAchieveId!)}");
    receivedAchieve = DetailReceivedAchieveModel.fromJson(response);
    circle = false;
    notifyListeners();
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

    Map<String, dynamic>? bodyReward;
    print(bodyReward);

    Map<String, String> headersReward = {
      'Authorization': 'Bearer $accessToken',
    };
    print(headersReward);
    print(achieveId);
    
    var response = await networkHandler.put("/student/getReward/${int.parse(achieveId!)}", headersReward, null);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Награда получена. Поздравляем!")));
      Navigator.pop(context);
      fetchDetailReceivedAchievement();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка при получении награды.")));
    }
  }
}