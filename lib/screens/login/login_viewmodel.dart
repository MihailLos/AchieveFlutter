import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginViewModel extends BaseViewModel {

  bool isHiddenPassword = true;
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  LoginViewModel(BuildContext context);

  Future onReady() async {

  }

  void changePasswordToggle() {
    isHiddenPassword = !isHiddenPassword;
    notifyListeners();
  }

  Future<void> loginAction(context) async {
    if (loginController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse("http://82.179.1.166:8080/authEios"),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'login': loginController.text,
            'password': passwordController.text
          }));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Авторизация прошла успешно!")));
        print(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Логин или пароль введены неверно!")));
        print(response.statusCode);
      }
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