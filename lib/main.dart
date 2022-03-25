import 'dart:io';

import 'package:achieve_student_flutter/screens/home_view.dart';
import 'package:achieve_student_flutter/screens/profile/profile_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:achieve_student_flutter/screens/login/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:lottie/lottie.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xFF4065D8)
    ),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Lottie.asset("assets/images/splash_logo.json"),
            Text(
              "Достижения",
              style: CyrillicFonts.raleway(
                  fontStyle: FontStyle.normal,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.68,
                  color: Colors.white),
            )
          ],
        ),
        backgroundColor: Color(0xFF4065D8),
        nextScreen: LoginScreen(),
        splashIconSize: 500,
        duration: 2000,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: Duration(seconds: 1),
    );
  }
}

