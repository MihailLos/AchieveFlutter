import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/achievement/created_achievement/detail_created_achievement.dart';
import 'package:achieve_student_flutter/utils/network_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:stacked/stacked.dart';

class CreatedDetailAchieveViewModel extends BaseViewModel {
  CreatedDetailAchieveViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  DetailCreatedAchieveModel? createdAchievement;
  FilePickerResult? filePickerResult;
  bool circle = true;
  var commentController = TextEditingController();

  Future onReady() async {
    fetchDetailCreatedAchievement();
    notifyListeners();
  }

  fetchDetailCreatedAchievement() async {
    String? createdAchieveId = await storage.read(key: "created_achieve_id");
    var response = await networkHandler.get("/student/achievementsCreated/${int.parse(createdAchieveId!)}");
    if (response.statusCode == 200 || response.statusCode == 200) {
      createdAchievement = DetailCreatedAchieveModel.fromJson(json.decode(response.body));
      circle = false;
      notifyListeners();
    } else if (response.statusCode == 403) {
      var response = await networkHandler.get("/newToken", {"Refresh": "Refresh ${await storage.read(key: "refresh_token")}"});
      await storage.write(key: "token", value: json.decode(response.body)["accessToken"]);
      return fetchDetailCreatedAchievement();
    }
  }

  Uint8List getImage(String base64String) {
    var firstDecode = base64Decode(base64String);
    String tempString = String.fromCharCodes(firstDecode).replaceAll("\n", "");
    var secondDecode = base64Decode(tempString);
    return secondDecode;
  }

  chooseFilesAction(context) async {
    filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: true);
    notifyListeners();
    if (filePickerResult == null) return;
  }

  openFiles(PlatformFile file) {
    OpenFile.open(file.path!);
  }

  convertToBase64(PlatformFile chooseFile) {
    File file = File(chooseFile.path!);
    var firstEncode = base64Encode(file.readAsBytesSync());
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    var secondEncode = stringToBase64.encode(firstEncode);
    return secondEncode;
  }

  sendButtonAction(context) async {
    String? unreceivedAchieveId = await storage.read(key: "created_achieve_id");
    var accessToken = await storage.read(key: "token");
    if (commentController.text.isNotEmpty && filePickerResult != null) {
      Map<String, dynamic> bodyProofData = {
        "achieveId": int.parse(unreceivedAchieveId!),
        "description": commentController.text,
        "files": filePickerResult!.files.length
      };

      Map<String, String> headersProof = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      var response = await networkHandler.post("/student/newProof", headersProof, bodyProofData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await storage.write(key: "list_file_id_for_proof", value: response.body);
        var listFileIdString = await storage.read(key: "list_file_id_for_proof");
        var listFileId = int.parse(listFileIdString!);
        for (var i = 0; i < filePickerResult!.files.length; i++) {
          Map<String, dynamic> bodyFileData = {
            "data": convertToBase64(filePickerResult!.files[i]),
            "format": filePickerResult!.files[i].extension,
            "listFileId": listFileId
          };

          Map<String, String> headersFile = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          };

          var response = await networkHandler.post("/student/newFile", headersFile, bodyFileData);

          if (response.statusCode != 200) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("?????? ???????????????? ?????????? ?????????????????? ????????????.")));
            return;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("???????????? ?????????????? ????????????????????????.")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("???????????? ?????? ???????????????? ????????????.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("?????????????????? ?????? ???????? ????????????!")));
    }
  }
}