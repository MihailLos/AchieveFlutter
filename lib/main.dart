import 'dart:io';

import 'package:achieve_student_flutter/screens/home_view.dart';
import 'package:achieve_student_flutter/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:achieve_student_flutter/screens/login/login_screen.dart';
import 'package:flutter/services.dart';

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
    home: LoginScreen(),
  ));
}
