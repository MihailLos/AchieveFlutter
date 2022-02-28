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

      var response = await networkHandler.post("/authEios", headers, bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> output = json.decode(response.body);
        await tokenStorage.write(key: "token", value: output["accessToken"]);
        Navigator.push(context, new MaterialPageRoute(builder: (context) => HomeView()));
      } else {
        SnackBar(content: Text("Логин или пароль введены неверно!"));
      }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Введите логин и пароль!")));
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

  showFaqScreen(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Icon(
              Icons.settings,
              color: Colors.green,
              size: 48,
            ),
            content: Text(
              "Авторизация студента производится при помощи логина и пароля от eios.kemsu.ru. Пожалуйста, обратитесь в дирекцию свего института для получения логина или пароля.",
              style: TextStyle(
                  fontFamily: "Montseratt",
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xFF757575)),
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}