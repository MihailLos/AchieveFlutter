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
        "login": loginController.text,
        "password": passwordController.text
      };

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, String> headersForTokenEios = {
        'Content-Type': 'application/json',
        'Application': 'application/json',
      };

      var response = await networkHandler.post("/authEios", headers, bodyData);
      var responseForTokenEios = await http.post(Uri.parse('https://api-next.kemsu.ru/api/auth'), headers: headersForTokenEios, body: jsonEncode(bodyData));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> output = json.decode(response.body);
        await tokenStorage.write(key: "token", value: output["accessToken"]);
        await tokenStorage.write(key: "refresh_token", value: output["refreshToken"]);
        if (responseForTokenEios.statusCode == 200 || responseForTokenEios.statusCode == 201) {
          Map<String, dynamic> outputForEiosToken = json.decode(response.body);
          await tokenStorage.write(key: "eios_token", value: outputForEiosToken["accessToken"]);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Не удалось подключиться к системе защиты ЭИОС. (Код ошибки: ${response.statusCode})")));
        }
        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => HomeView()), (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Авторизация прошла успешно.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Логин или пароль введены неверно! (Код ошибки: ${response.statusCode})")));
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