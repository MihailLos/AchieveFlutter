import 'package:achieve_student_flutter/screens/pgas/edit_pgas_request_screen.dart';
import 'package:achieve_student_flutter/screens/pgas/pgas_request_info_screen.dart';
import 'package:achieve_student_flutter/screens/pgas/pgas_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class PgasDetailViewModel extends BaseViewModel {
  PgasDetailViewModel(BuildContext context);
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future onReady() async {

  }

  goToEditPgasRequestScreen(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => EditPgasRequestScreen()));
  }

  goToPgasRequestInfoScreen(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => PgasRequestInfoScreen()));
  }
}