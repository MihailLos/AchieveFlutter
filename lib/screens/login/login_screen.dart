import 'package:achieve_student_flutter/screens/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
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
        onModelReady: (viewModel) => viewModel.onReady(context),
        builder: (context, model, child) {
          return Scaffold(
            body: _body(context, model),
          );
        });
  }

  _body(context, LoginViewModel model) {
    return model.circle ? const Center(child: CircularProgressIndicator(),) : Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.5, -0.7),
            colors: [
              Color(0xFF39ABDF),
              Color(0xFF5878DD)
            ]
          )
        ),
        child: SafeArea(child: _loginSpace(context, model))
    );
  }

  _loginSpace(context, model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _achievementsLabel(),
          const SizedBox(
            height: 21,
          ),
          _loginTextField(context, model),
          const SizedBox(
            height: 21,
          ),
          _passwordTextField(context, model),
          const SizedBox(
            height: 21,
          ),
          _loginButton(context, model),
          const SizedBox(
            height: 22,
          ),
          _bottomInfo(context, model)
        ],
      ),
    );
  }

  _achievementsLabel() {
    return Text(
      "Достижения",
      style: CyrillicFonts.raleway(
          fontStyle: FontStyle.normal,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.68,
          color: Colors.white),
    );
  }

  _loginTextField(context, model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
      child: SizedBox(
        width: double.maxFinite,
        height: 46,
        child: TextField(
          autofillHints: const [AutofillHints.username],
          controller: model.loginController,
          obscureText: false,
          style: const TextStyle(fontFamily: 'OpenSans', fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              fillColor: Colors.transparent,
              filled: true,
              hintText: "Логин ЭИОС",
              hintStyle: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  _passwordTextField(context, model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
      child: SizedBox(
        width: double.maxFinite,
        height: 46,
        child: TextField(
          autofillHints: const [AutofillHints.password],
          onEditingComplete: () => TextInput.finishAutofillContext(),
          controller: model.passwordController,
          obscureText: model.isHiddenPassword,
          style: const TextStyle(fontFamily: 'OpenSans', fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              fillColor: Colors.transparent,
              filled: true,
              hintText: "Пароль",
              suffixIcon: IconButton(
                icon: model.isHiddenPassword
                    ? const Icon(Icons.visibility_off, color: Colors.white,)
                    : const Icon(Icons.visibility, color: Colors.white,),
                onPressed: model.changePasswordToggle,
              ),
              hintStyle: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  _loginButton(context, model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
      child: Container(
          width: double.maxFinite,
          height: 46,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 6),
                spreadRadius: 1,
                blurRadius: 7
              )
            ],
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFBC89),
                Color(0xFFFF9A67)
              ],
            ),
          ),
          child: TextButton(
            onPressed: () async {
              model.loginAction(context);
            },
            child: Text(
              "Войти",
              style: CyrillicFonts.raleway(
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,),
            ),

          )
      ),
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
            child: const Text(
              "Забыли пароль?",
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  color: Colors.white),
            )),
        TextButton(
            onPressed: () {
              _showFaqScreen(context);
            },
            child: const Text(
              "Как войти?",
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  color: Color(0xFFFFBC89)),
            )),
      ],
    );
  }

  _showFaqScreen(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
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
