import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Достижения",
                style: TextStyle(
                    fontFamily: "Montseratt",
                    fontStyle: FontStyle.normal,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.07),
              ),
              SizedBox(
                height: 21,
              ),
              Container(
                width: 366,
                height: 46,
                child: TextField(
                  controller: loginController,
                  obscureText: false,
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                      fillColor: Color(0xfff3f2f2),
                      filled: true,
                      hintText: "Логин Eios"),
                ),
              ),
              SizedBox(
                height: 21,
              ),
              Container(
                width: 366,
                height: 46,
                child: TextField(
                  controller: passwordController,
                  obscureText: isHiddenPassword,
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                      fillColor: Color(0xfff3f2f2),
                      filled: true,
                      hintText: "Пароль",
                      suffixIcon: IconButton(
                        icon: isHiddenPassword
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: changePasswordToggle,
                      )),
                ),
              ),
              SizedBox(
                height: 21,
              ),
              Container(
                  width: 366,
                  height: 46,
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xffbfbfbf),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: login,
                    child: Text(
                      "Войти",
                      style: TextStyle(
                          fontFamily: "Montseratt",
                          fontStyle: FontStyle.normal,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Color(0xFFFF9966),
                    ),
                  )),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Забыли пароль?",
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            color: Color(0xFF757575)),
                      )),
                  TextButton(
                      onPressed: () {
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
                      },
                      child: Text(
                        "Как войти?",
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            color: Color(0xFFFF9966)),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void changePasswordToggle() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void showFaqDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Icon(
        Icons.settings,
        color: Colors.green,
      ),
      content: Text(
          "Авторизация студента производится при помощи логина и пароля от eios.kemsu.ru. Пожалуйста, обратитесь в дирекцию свего института для получения логина или пароля."),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Future<void> login() async {
    if (loginController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse("http://82.179.1.166:8080/authEios"),
          headers: <String, String> {
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
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Пустые поля не допустимы!")));
    }
  }
}
