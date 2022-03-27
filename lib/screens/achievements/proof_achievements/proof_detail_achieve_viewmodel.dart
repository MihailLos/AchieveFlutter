import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/proof_achievement/detail_proof_achievement.dart';
import 'package:achieve_student_flutter/utils/network_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

class ProofDetailAchieveViewModel extends BaseViewModel {
  ProofDetailAchieveViewModel(BuildContext context);

  FlutterSecureStorage storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  DetailProofAchieveModel? proofAchievement;
  bool circle = true;

  Future onReady() async {
    fetchDetailProofAchievement();
    notifyListeners();
  }

  fetchDetailProofAchievement() async {
    String? proofAchieveId = await storage.read(key: "proof_achieve_id");
    var response = await networkHandler.get("/student/proof/${int.parse(proofAchieveId!)}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      proofAchievement = DetailProofAchieveModel.fromJson(json.decode(response.body));
      circle = false;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchDetailProofAchievement();
    }
  }

  Uint8List getImage(String base64String) {
    var firstDecode = base64Decode(base64String);
    String tempString = String.fromCharCodes(firstDecode).replaceAll("\n", "");
    var secondDecode = base64Decode(tempString);
    return secondDecode;
  }
}