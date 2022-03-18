import 'dart:convert';

import 'package:achieve_student_flutter/screens/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:achieve_student_flutter/network_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginViewModel extends BaseViewModel {

  var loginController = TextEditingController();
  var passwordController = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage tokenStorage = FlutterSecureStorage();


  bool isHiddenPassword = true;

  LoginViewModel();

  LoginViewModel.withContext(BuildContext context);

  Future onReady() async {

  }

  void changePasswordToggle() {
    isHiddenPassword = !isHiddenPassword;
    notifyListeners();
  }

  void loginAction(context) async {
    if (loginController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      Map<String, String> bodyData = {
        "email": loginController.text,
        "password": passwordController.text
      };

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      var response = await networkHandler.post("/auth", headers, bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> output = json.decode(response.body);
        await tokenStorage.write(key: "token", value: output["accessToken"]);
        await tokenStorage.write(key: "refresh_token", value: output["refreshToken"]);
        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => HomeView()), (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Авторизация прошла успешно.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Логин или пароль введены неверно!")));
      }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Введите логин и пароль!")));
        // print(response.statusCode);
      }
    }


  launchRecoveryPasswordURL() async {
    const url = "https://eios.kemsu.ru/a/eios";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Невозможно вызвать веб-сайт для восстановления пароля';
    }
  }
}