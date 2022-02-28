import 'package:achieve_student_flutter/screens/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginScreenRoute extends MaterialPageRoute {
  LoginScreenRoute() : super(builder: (context) => const LoginScreen());
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel.withContext(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            body: _body(context, model),
          );
        });
  }

  _body(context, model) {
    return SafeArea(child: _loginSpace(context, model));
  }

  _loginSpace(context, model) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _achievementsLabel(),
            SizedBox(
              height: 21,
            ),
            _loginTextField(context, model),
            SizedBox(
              height: 21,
            ),
            _passwordTextField(context, model),
            SizedBox(
              height: 21,
            ),
            _loginButton(context, model),
            SizedBox(
              height: 22,
            ),
            _bottomInfo(context, model)
          ],
        ),
      ),
    );
  }

  _achievementsLabel() {
    return Text(
      "Достижения",
      style: TextStyle(
          fontFamily: "Montseratt",
          fontStyle: FontStyle.normal,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.07),
    );
  }

  _loginTextField(context, model) {
    return Container(
      width: 350,
      height: 46,
      child: TextField(
        controller: model.loginController,
        obscureText: false,
        style: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            fillColor: Color(0xfff3f2f2),
            filled: true,
            hintText: "Логин Eios"),
      ),
    );
  }

  _passwordTextField(context, model) {
    return Container(
      width: 350,
      height: 46,
      child: TextField(
        controller: model.passwordController,
        obscureText: model.isHiddenPassword,
        style: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            fillColor: Color(0xfff3f2f2),
            filled: true,
            hintText: "Пароль",
            suffixIcon: IconButton(
              icon: model.isHiddenPassword
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
              onPressed: model.changePasswordToggle,
            )),
      ),
    );
  }

  _loginButton(context, model) {
    return Container(
        width: 350,
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
          onPressed: () async {
            model.loginAction(context);
          },
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
        )
    );
  }

  _bottomInfo(context, model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
            onPressed: () async {
              model.launchRecoveryPasswordURL();
            },
            child: Text(
              "Забыли пароль?",
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  color: Color(0xFF757575)),
            )),
        TextButton(
            onPressed: () {
              model.showFaqScreen(context);
            },
            child: Text(
              "Как войти?",
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  color: Color(0xFFFF9966)),
            )),
      ],
    );
  }
}
