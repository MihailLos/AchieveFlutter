import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;

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
                    onPressed: () {},
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
                      )
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Как войти?",
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            color: Color(0xFFFF9966)),
                      )
                  ),
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
}
